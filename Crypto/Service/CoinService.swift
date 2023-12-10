//
//  CoinService.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import SwiftUI
import Combine

class CoinService {
        
    @Published var allCoins: [CoinModel] = []
    @Published var marketData: MarketDataModel?
    
    var coinSubscription: AnyCancellable?
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getCoins()
        getMarketData()
    }

    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubscription = dowload(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: handleCompletion(completion:), receiveValue: { [weak self] allCoins in
                self?.allCoins = allCoins
                self?.coinSubscription?.cancel()
            })
    }
    
    func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = dowload(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: handleCompletion(completion:), receiveValue: { [weak self] globalData in
                self?.marketData = globalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
    
    private func dowload(url: URL) -> AnyPublisher<Data,Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Finished fetching transactions")
        case .failure(let error):
            print("Failed fetching transactions \(error.localizedDescription)")
        }
    }
}
