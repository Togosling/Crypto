//
//  PortfolioView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/9.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var selectedCoin: CoinModel?
    @State private var quantityText: String = ""
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                VStack {
                    
                    SearchBarView(searchText: $homeViewModel.searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil {
                        inputAmountHoldingsView
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Xmark()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        saveInput()
                    }, label: {
                        Text("SAVE")
                            .bold()
                    })
                    .opacity(quantityText.isEmpty ? 0.0 : 1.0)
                }
            })
        }
    }
}

extension PortfolioView {
    
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(homeViewModel.allCoins) { coin in
                    CoinIconView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            selectedCoin = coin
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(selectedCoin?.id == coin.id ? Color.accent : Color.clear, lineWidth: 1.0)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
    
    private var inputAmountHoldingsView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount of holdings:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .font(.headline)
        .padding()
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveInput() {
        UIApplication.shared.endEditing()
        quantityText = ""
    }
}
