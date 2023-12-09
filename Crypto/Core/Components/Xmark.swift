//
//  Xmark.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/9.
//

import SwiftUI

struct Xmark: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss.callAsFunction()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    Xmark()
}
