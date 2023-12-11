//
//  CoinDetailView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/11.
//

import SwiftUI

struct CoinDetailView: View {
    
    @StateObject private var coinDetailViewModel: CoinDetailViewModel
    @State private var showDescription: Bool = false
    
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
                    
                    VStack(alignment: .leading) {
                        if let description = coinDetailViewModel.description {
                            Text(description)
                                .lineLimit(showDescription ? nil : 3)
                                .font(.callout)
                                .foregroundStyle(Color.secondaryText)
                    
                            Button(showDescription ? "Less" : "See more ...") {
                                withAnimation(.easeOut) {
                                    showDescription.toggle()
                                }
                            }
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                        }
                    }
                    
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
                    
                    HStack {
                        if let website = coinDetailViewModel.website, let url = URL(string: website) {
                            Link(destination: url, label: {
                                Text("Website")
                                    .font(.headline)
                            })
                        }
                        
                        Spacer()
                        
                        if let reddit = coinDetailViewModel.reddit, let url = URL(string: reddit)  {
                            Link(destination: url, label: {
                                Text("Reddit")
                                    .font(.headline)
                            })
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
