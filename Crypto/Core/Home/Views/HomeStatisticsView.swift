//
//  HomeStatisticsView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/9.
//

import SwiftUI

struct HomeStatisticsView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(homeViewModel.statisctics) {statistic in
                StatiscticView(statistic: statistic)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

//#Preview {
//    HomeStatisticsView(showPortfolio: .constant(false))
//}
