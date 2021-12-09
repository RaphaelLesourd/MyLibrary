//
//  Converter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/11/2021.
//

import Foundation

protocol FormatterProtocol {
    func joinArrayToString(_ dataArray: [String]?) -> String
    func formatStringToInt(_ value: String?) -> Int
    func formatCurrency(with value: Double?, currencyCode: String?) -> String
    func formatDateToYearString(for dateString: String?) -> String
    func formatDecimalString(_ decimalString: String?) -> Double
    func formatCodeToName(from code: String?, type: CodeType) -> String
    func formatTimeStampToRelativeDate(for timestamp: Double?) -> String
}

class Formatter: FormatterProtocol {
    
    func joinArrayToString(_ dataArray: [String]?) -> String {
        guard let dataArray = dataArray else {
            return ""
        }
        return dataArray.joined(separator: ", ")
    }
    
    func formatTimeStampToRelativeDate(for timestamp: Double?) -> String {
        guard let timestamp = timestamp else {
            return ""
        }
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .numeric
        if let preferedLanguage = Locale.preferredLanguages.first {
            formatter.locale = Locale.init(identifier: preferedLanguage)
        }
        return formatter.string(for: Date(timeIntervalSince1970: timestamp))!
    }
    
    func formatDateToYearString(for dateString: String?) -> String {
        guard let dateString = dateString else {
            return ""
        }
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        let date = inputDateFormatter.date(from: dateString) ?? Date()
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy"
        return outputDateFormatter.string(from: date)
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
    
    func formatStringToInt(_ value: String?) -> Int {
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
        let number = NSNumber(value: value ?? 0)
        return formatter.string(from: number)!
    }
    
    func formatCodeToName(from code: String?, type: CodeType) -> String {
        guard let code = code else { return "" }
        let currentIdentifier = Locale.current.regionCode ?? ""
        let localeFromCurrentIdentifier = Locale(identifier: currentIdentifier)
        switch type {
        case .language:
            return localeFromCurrentIdentifier.localizedString(forLanguageCode: code) ?? ""
        case .currency:
            return localeFromCurrentIdentifier.localizedString(forCurrencyCode: code) ?? ""
        }
    }
    
}
