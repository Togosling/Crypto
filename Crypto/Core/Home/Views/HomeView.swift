//
//  HomeView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State var showPortfolio: Bool = false
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack {
                
                headerView
                
                columnTitles
                
                coinsList
                
                Spacer()
            }
        }
    }
}

extension HomeView {
    
    private var headerView: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .transaction { transaction in
                    transaction.animation = nil
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .transaction { transaction in
                    transaction.animation = nil
                }
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.accent)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
    }
    
    private var coinsList: some View {
        List {
            ForEach(showPortfolio ? homeViewModel.portfolioCoins : homeViewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldings: showPortfolio)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
        .transition(.move(edge: showPortfolio ? .trailing : .leading))
        .scrollIndicators(.hidden)
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            
            Spacer()
            
            if showPortfolio {
                Text("Holdings")
            }
            
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.secondaryText)
        .padding(.horizontal)
    }
}
