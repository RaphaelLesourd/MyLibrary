//
//  Double+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 15/11/2021.
//

import Foundation

extension Double {
    
    /// Format a price
    /// - Note: We can safely force-unwrap the optional that NumberFormatter returns from the call,
    /// since we’re in complete control over the NSNumber that is being passed into it.
    /// - Parameter currencyCode: 3 letters currency code (ie: EUR, USD etc)
    /// - Returns: Formatted price with currency symbal and remova lof trailing 0.
    func formatCurrency(currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = currencyCode
        formatter.positivePrefix = "\(formatter.positivePrefix ?? "") "
        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }
}
