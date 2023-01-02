//
//  Double+extensions.swift
//  Budget
//
//  Created by Baris on 1.01.2023.
//

import Foundation
extension Double {
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
    
}
