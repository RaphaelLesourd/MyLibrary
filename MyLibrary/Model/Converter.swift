//
//  Converter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/11/2021.
//

import Foundation

class Converter {
    
    func joinArrayToString(_ dataArray: [String]?) -> String {
        guard let dataArray = dataArray else {
            return ""
        }
        return dataArray.joined(separator: ", ")
    }
    
    func displayYearOnly(for dateString: String?) -> String {
        guard let dateString = dateString else {
            return ""
        }

        let inputDateFormatter = DateFormatter()
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy"
        
        let formats: [String] = [
            "yyyy-MM-dd hh:mm:ss.SSSSxx",
            "yyyy-MM-dd hh:mm:ss.SSSxxx",
            "yyyy-MM-dd hh:mm:ss.SSxxxx",
            "yyyy-MM-dd hh:mm:ss.Sxxxxx",
            "yyyy-MM-dd hh:mm:ss",
            "yyyy-MM-dd",
            "yyyy"
        ]
        for format in formats {
            inputDateFormatter.dateFormat = format
            
            if let date = inputDateFormatter.date(from: dateString) {
                return outputDateFormatter.string(from: date)
            }
        }
        return ""
    }
    
    func formatDecimalString(_ decimalString: String?) -> Double {
        guard let decimalString = decimalString else {
            return 0
        }
        let convertedString = decimalString.split {
            !CharacterSet(charactersIn: "\($0)").isSubset(of: CharacterSet.decimalDigits)
        }.joined(separator: ".")
        return Double(convertedString) ?? 0
    }
    
    func setTimestamp(for timestamp: Double?) -> Double {
            return timestamp ?? Date().timeIntervalSince1970
    }
    
    func convertStringToInt(_ value: String?) -> Int {
        guard let value = value else {
            return 0
        }
        return NumberFormatter().number(from: value)?.intValue ?? 0
    }
    
    /// Format a price
    /// - Note: We can safely force-unwrap the optional that NumberFormatter returns from the call,
    /// since we’re in complete control over the NSNumber that is being passed into it.
    /// - Parameter currencyCode: 3 letters currency code (ie: EUR, USD etc)
    /// - Returns: Formatted price with currency symbal and remova lof trailing 0.
    func formatCurrency(with value: Double?, currencyCode: String?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = currencyCode ?? "EUR"
        formatter.positivePrefix = "\(formatter.positivePrefix ?? "") "
        let number = NSNumber(value: value ?? 0)
        return formatter.string(from: number)!
    }
    
    func getlanguageName(from languageCode: String?) -> String {
        guard let languageCode = languageCode else {
            return ""
        }
        let currentIdentifier = Locale.current.regionCode ?? ""
        let localeFromCurrentIdentifier = Locale(identifier: currentIdentifier)
        return localeFromCurrentIdentifier.localizedString(forLanguageCode: languageCode) ?? ""
    }
    
    func getCurrencySymbol(from currencyCode: String?) -> String {
        guard let currencyCode = currencyCode else {
            return ""
        }
        let currentIdentifier = Locale.current.regionCode ?? ""
        let localeFromCurrentIdentifier = Locale(identifier: currentIdentifier)
        return localeFromCurrentIdentifier.localizedString(forCurrencyCode: currencyCode) ?? ""
    }
 
    func isIsbn(_ value: String) -> Bool {
        return (value.count >= 10 ) && value.allSatisfy { $0.isNumber }
    }
}
