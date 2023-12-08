//
//  Application.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/8.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
