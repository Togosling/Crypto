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
    @State var showPortfolioView: Bool = false
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(homeViewModel)
                }
            
            VStack {
                
                headerView
                
                HomeStatisticsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $homeViewModel.searchText)
                
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
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
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
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(homeViewModel.sortOption == .rank || homeViewModel.sortOption == .rankReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: homeViewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    homeViewModel.sortOption = homeViewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(homeViewModel.sortOption == .holdings || homeViewModel.sortOption == .holdingsReversed ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: homeViewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        homeViewModel.sortOption = homeViewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(homeViewModel.sortOption == .price || homeViewModel.sortOption == .priceReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: homeViewModel.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    homeViewModel.sortOption = homeViewModel.sortOption == .price ? .priceReversed : .price
                }
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
            Button(action: {
                withAnimation(.linear(duration: 2.0)) {
                    homeViewModel.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: homeViewModel.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundStyle(Color.secondaryText)
        .padding(.horizontal)
    }
}
