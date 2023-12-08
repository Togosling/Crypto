//
//  CryptoApp.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import SwiftUI

@main
struct CryptoApp: App {
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .environmentObject(homeViewModel)
        }
    }
}
