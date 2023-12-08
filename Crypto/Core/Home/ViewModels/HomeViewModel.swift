//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    init() {
        CoinService.shared.getCoins { [weak self] allCoins in
            self?.allCoins = allCoins
        }
    }
}
