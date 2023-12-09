//
//  CoinIconView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/9.
//

import SwiftUI

struct CoinIconView: View {
    
    let coin: CoinModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: coin.image)) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

//#Preview {
//    CoinIconView()
//}
