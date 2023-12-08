//
//  CoinService.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import SwiftUI
import Combine

class CoinService {
    
    static let shared = CoinService()
    
    var coinSubscription: AnyCancellable?
    
    var coinImageSubscription: AnyCancellable?

    func getCoins(completion: @escaping ([CoinModel]) -> ()) {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubscription = dowload(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: handleCompletion(completion:), receiveValue: { [weak self] allCoins in
                completion(allCoins)
                self?.coinSubscription?.cancel()
            })
    }
    
    func getCoinImage(urlString: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        coinImageSubscription = dowload(url: url)
            .tryMap({ data in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: handleCompletion(completion:), receiveValue: { [weak self] coinImage in
                completion(coinImage)
                self?.coinImageSubscription?.cancel()
            })
    }
    
    func dowload(url: URL) -> AnyPublisher<Data,Error> {
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
    
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Finished fetching transactions")
        case .failure(let error):
            print("Failed fetching transactions \(error.localizedDescription)")
        }
    }
}
