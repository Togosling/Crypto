//
//  CoinDetailViewModel.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/11.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    
    @Published var overviewStatistics = [StatisticModel]()
    @Published var additionalStatistics = [StatisticModel]()
    @Published var coinDetails: CoinDetailModel?
    @Published var coin: CoinModel

    private var coinDetailsService: CoinDetailService
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel) {
        self.coin = coin
        coinDetailsService = CoinDetailService(coin: coin)
        addSubscribers()
    }
    
    //MARK: - Private
    
    func addSubscribers() {
        coinDetailsService.$coinDetails
            .combineLatest($coin)
            .map({(coinDetails, coin) -> (overview: [StatisticModel], additional: [StatisticModel]) in
                
                let price = coin.currentPrice.asCurrencyWith6Decimals()
                let priceChange = coin.priceChangePercentage24H
                let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: priceChange)
                
                let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
                let marketCapChange = coin.marketCapChangePercentage24H
                let marketStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)
                
                let rank = "\(coin.rank)"
                let rankStat = StatisticModel(title: "Rank", value: rank)
                
                let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
                let volumeStat = StatisticModel(title: "Volume", value: volume)
                
                let overviewArray = [priceStat, marketStat, rankStat, volumeStat]

                let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
                let highStat = StatisticModel(title: "24h High", value: high)
                
                let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
                let lowStat = StatisticModel(title: "24h Low", value: low)
                
                let priceChange2 = coin.priceChangePercentage24H?.asCurrencyWith6Decimals() ?? "n/a"
                let pricePercentChange2 = coin.priceChangePercentage24H
                let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange2, percentageChange: pricePercentChange2)
                
                let marketChange2 = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
                let marketCapChange2 = coin.marketCapChangePercentage24H
                let marketCapChangeStat = StatisticModel(title: "24h Market CAP Change", value: marketChange2, percentageChange: marketCapChange2)
                
                let hashing = coinDetails?.hashingAlgorithm ?? "n/a"
                let hashingStat = StatisticModel(title: "Hashing Alghoritm", value: hashing)
                
                let blockTime = coinDetails?.blockTimeInMinutes ?? 0
                let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
                let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
                
                let additionalArray = [highStat, lowStat, priceChangeStat, marketCapChangeStat, hashingStat, blockTimeStat]
                
                return (overviewArray, additionalArray)
                  })
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
    }
}
