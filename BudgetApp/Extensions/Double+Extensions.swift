//
//  Double+Extensions.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import Foundation

extension NumberFormatter {
    
    static var currency: NumberFormatter = {        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //return formatter.string(from: NSNumber(value: self)) ?? ""
        return formatter
    }()
    
}
