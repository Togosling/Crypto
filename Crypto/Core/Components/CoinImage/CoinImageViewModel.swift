//
//  CoinImageViewModel.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import SwiftUI

class CoinImageViewModel: ObservableObject {
    
    @Published var coinImage: UIImage?
    @Published var isLoading: Bool = false
    
    init(coin: CoinModel) {
        CoinService.shared.getCoinImage(urlString: coin.image) {[weak self] coinImage in
            self?.coinImage = coinImage
        }
    }
}
