//
//  SearchBarView.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(searchText.isEmpty ? Color.secondaryText : Color.accent)
            
            TextField("Search by name ...", text: $searchText) {
                UIApplication.shared.endEditing()
            }
                .foregroundStyle(Color.accent)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(Color.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        },
                    alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .foregroundStyle(Color.background)
                .shadow(color: Color.accent.opacity(0.15),radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        )
        .padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
