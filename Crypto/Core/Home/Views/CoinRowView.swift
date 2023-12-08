//
//  CoinRowView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldings: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.accent)
            
            Spacer()
        
            if showHoldings {
                VStack(alignment: .trailing) {
                    Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                        .bold()
                    Text((coin.currentHoldings ?? 0).asNumberString())
                }
                .foregroundStyle(Color.accent)
            }
            
            VStack(alignment: .trailing) {
                Text(coin.currentPrice.asCurrencyWith6Decimals())
                    .bold()
                    .foregroundStyle(Color.accent)
                Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                    .foregroundStyle(coin.priceChangePercentage24H ?? 0 >= 0 ? Color.customGreen : Color.customRed)
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.subheadline)
    }
}
