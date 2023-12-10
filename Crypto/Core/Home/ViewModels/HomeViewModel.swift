//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import Foundation
import Combine

enum SortOptions {
    case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
}

class HomeViewModel: ObservableObject {
    
    @Published var statisctics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOptions = .rank
    
    private var coinService = CoinService()
    private var portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    //MARK: - Public
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinService.getCoins()
        coinService.getMarketData()
    }
    
    //MARK: - Private
    
    private func addSubscribers() {
        coinSubscription()
        portfolioDataSubscription()
        marketDataSubscription()
    }
    
    private func coinSubscription() {
        $searchText
            .combineLatest(coinService.$allCoins, $sortOption)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] filteredCoins in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)
    }
    
    private func marketDataSubscription() {
        coinService.$marketData
            .combineLatest($portfolioCoins)
            .map { (marketData, portfolioCoins) in
                var statistics = [StatisticModel]()

                guard let marketData = marketData else { return statistics}
                
                let marketCap = StatisticModel(title: "Market Cap", value: marketData.marketCap, percentageChange: marketData.marketCapChangePercentage24HUsd)
                let volume = StatisticModel(title: " 24h Volume", value: marketData.volume)
                let btcDominance = StatisticModel(title: "BTC Dominance", value: marketData.btcDominance)
                
                let portfolioValue = portfolioCoins
                    .map({ $0.currentHoldingsValue})
                    .reduce(0, +)
                
                let previousValue = portfolioCoins
                    .map { (coin) -> Double in
                        let currentValue = coin.currentHoldingsValue
                        let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                        let previousValue = currentValue / (1 + percentChange)
                        return previousValue
                    }
                    .reduce(0, +)

                let percentChange = (portfolioValue - previousValue) / previousValue * 100
                
                let portfolio = StatisticModel(title: "Portfolio", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentChange)
                
                statistics.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
                
                return statistics
            }
            .sink { [weak self] statisticsModels in
                self?.statisctics = statisticsModels
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func portfolioDataSubscription() {
        $allCoins
            .combineLatest(portfolioDataService.$saveEntities)
            .map { (coinModels, portfolioEntites) -> [CoinModel] in
                coinModels.compactMap { (coin) -> CoinModel? in
                    guard let entity = portfolioEntites.first(where: { $0.coinId == coin.id}) else {
                        return nil
                    }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .sink { [unowned self] returnedCoins in
                self.portfolioCoins = self.sortCoins(coins: returnedCoins, sort: self.sortOption)
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOptions) -> [CoinModel] {
        var sortedCoins = sortCoins(coins: coins, sort: sort)

        guard !text.isEmpty else { return sortedCoins }
        
        let loweredSearchText = text.lowercased()
        
        return sortedCoins.filter { coin in
            return coin.name.lowercased().contains(loweredSearchText) ||
            coin.symbol.lowercased().contains(loweredSearchText) ||
            coin.id.lowercased().contains(loweredSearchText)
        }
    }
    
    private func sortCoins(coins: [CoinModel], sort: SortOptions) -> [CoinModel] {
        switch sort {
        case .rank:
            return coins.sorted(by: { $0.rank < $1.rank})
        case .rankReversed:
            return coins.sorted(by: { $0.rank > $1.rank})
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue})
        case .price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice})
        case .priceReversed:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice})
        }
    }
}
