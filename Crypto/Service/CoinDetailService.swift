//
//  CoinDetailService.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/11.
//

import Foundation
import Combine

class CoinDetailService {
    
    @Published var coinDetails: CoinDetailModel?
    
    var coinDetailSubscription: AnyCancellable?
    
    init(coin: CoinModel) {
        getCoinDetails(coin: coin)
    }

    func getCoinDetails(coin: CoinModel) {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = NetworkManager.shared.dowload(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.shared.handleCompletion(completion:), receiveValue: { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            })
    }
}
