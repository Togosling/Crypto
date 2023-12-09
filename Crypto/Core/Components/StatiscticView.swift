//
//  StatiscticView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/9.
//

import SwiftUI

struct StatiscticView: View {
    
    let statistic: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
            Text(statistic.value)
                .font(.headline)
                .foregroundStyle(Color.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: statistic.percentageChange ?? 0 >= 0 ? 0 : 180))
                Text(statistic.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(statistic.percentageChange ?? 0 >= 0 ? Color.customGreen : Color.red)
            .opacity(statistic.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

#Preview {
    StatiscticView(statistic: StatisticModel(title: "Title", value: "Value", percentageChange: 25.3))
}
