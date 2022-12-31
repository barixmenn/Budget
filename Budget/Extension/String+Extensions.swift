//
//  String+Extensions.swift
//  Budget
//
//  Created by Baris on 31.12.2022.
//

import Foundation
extension String {
    
    var isNumeric: Bool {
        Double(self) != nil
    }
    
    func isGreatorThan(_ value: Double) -> Bool {
        
        guard self.isNumeric else {
            return false
        }
        
        return Double(self)! > value
    }
    
}
