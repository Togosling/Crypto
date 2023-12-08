//
//  CircleButtonView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(Color.background)
            )
            .shadow(color: Color.accent.opacity(0.3), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 0)
            .padding()
    }
}

#Preview {
    CircleButtonView(iconName: "heart.fill")
}
