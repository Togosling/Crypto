//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statisctics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private var coinService = CoinService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinSubscription()
        marketDataSubscription()
    }
    
    private func coinSubscription() {
        $searchText
            .combineLatest(coinService.$allCoins)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map {(searchText, allCoins) -> [CoinModel] in
                guard !searchText.isEmpty else { return allCoins}
                
                let loweredSearchText = searchText.lowercased()
                
                return allCoins.filter { coin in
                    return coin.name.lowercased().contains(loweredSearchText) ||
                    coin.symbol.lowercased().contains(loweredSearchText) ||
                    coin.id.lowercased().contains(loweredSearchText)
                }
            }
            .sink { [weak self] filteredCoins in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)
    }
    
    private func marketDataSubscription() {
        coinService.$marketData
            .map { marketData in
                var statistics = [StatisticModel]()

                guard let marketData = marketData else { return statistics}
                
                let marketCap = StatisticModel(title: "Market Cap", value: marketData.marketCap, percentageChange: marketData.marketCapChangePercentage24HUsd)
                let volume = StatisticModel(title: " 24h Volume", value: marketData.volume)
                let btcDominance = StatisticModel(title: "BTC Dominance", value: marketData.btcDominance)
                let portfolio = StatisticModel(title: "Portfolio", value: "$0.0", percentageChange: 0.0)
                
                statistics.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
                
                return statistics
            }
            .sink { [weak self] statisticsModels in
                self?.statisctics = statisticsModels
            }
            .store(in: &cancellables)
    }
}
