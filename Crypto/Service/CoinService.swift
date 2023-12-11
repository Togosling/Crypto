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
        
        coinSubscription = NetworkManager.shared.dowload(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.shared.handleCompletion(completion:), receiveValue: { [weak self] allCoins in
                self?.allCoins = allCoins
                self?.coinSubscription?.cancel()
            })
    }
    
    func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkManager.shared.dowload(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.shared.handleCompletion(completion:), receiveValue: { [weak self] globalData in
                self?.marketData = globalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
