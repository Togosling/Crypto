//
//  CoinImageView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject var coinImageViewModel: CoinImageViewModel
    
    init(coin: CoinModel) {
        _coinImageViewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = coinImageViewModel.coinImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
    }
}
