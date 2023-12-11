//
//  String.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/11.
//

import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
