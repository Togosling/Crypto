//
//  CoinDetailView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/11.
//

import SwiftUI

struct CoinDetailView: View {
    
    @StateObject private var coinDetailViewModel: CoinDetailViewModel
    
    private var columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(coin: CoinModel) {
        _coinDetailViewModel = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: coinDetailViewModel.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    Text("Overview")
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    LazyVGrid(columns: columns,
                              alignment: .leading,
                              spacing: 20,
                              pinnedViews: []) {
                        ForEach(coinDetailViewModel.overviewStatistics) { stat in
                            StatiscticView(statistic: stat)
                        }
                    }
                    
                    Text("Additional Details")
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    LazyVGrid(columns: columns,
                              alignment: .leading,
                              spacing: 20,
                              pinnedViews: []) {
                        ForEach(coinDetailViewModel.additionalStatistics) { stat in
                            StatiscticView(statistic: stat)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(coinDetailViewModel.coin.id.uppercased())
        .navigationBarTitleDisplayMode(.large)
        .toolbar(content: {
            ToolbarItem {
                HStack {
                    Text(coinDetailViewModel.coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundStyle(Color.secondaryText)
                    AsyncImage(url: URL(string: coinDetailViewModel.coin.image)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 25, height: 25)
                }
            }
        })
    }
}
