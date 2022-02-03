//
//  Converter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/11/2021.
//

import Foundation

class Formatter: FormatterProtocol {
    /// Format a timeStamp to a time ago string.
    /// - Parameters:
    ///  - timestamp: Otional Double
    /// - Returns: String
    /// - Note: Returns a string in the device prefered language.
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
    
    /// Format a Date String to Year only String.
    ///  - Parameters:
    ///     - dateString: Optional String
    ///  - Returns: Four digits Year String
    ///  - Note: If date is already forrmatted , simply return the current value.
    func formatDateToYearString(for dateString: String?) -> String {
        guard let dateString = dateString else {
            return ""
        }
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy"
        
        guard let date = inputDateFormatter.date(from: dateString) else {
            return (outputDateFormatter.date(from: dateString) != nil) ? dateString : ""
        }
        return outputDateFormatter.string(from: date)
    }
    /// Format a price
    /// - Note: We can safely force-unwrap the optional that NumberFormatter returns from the call,
    /// since we’re in complete control over the NSNumber that is being passed into it.
    /// - Parameters:
    ///  - currencyCode: 3 letters currency code (ie: EUR, USD etc)
    /// - Returns: Formatted price with currency symbal and remova lof trailing 0.
    func formatDoubleToPrice(with value: Double?, currencyCode: String?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = .current
        formatter.currencyCode = currencyCode ?? "EUR"
        let number = NSNumber(value: value ?? 0)
        let stringValue = formatter.string(from: number)!
        return stringValue.replacingOccurrences(of: ".00", with: "")
    }
    
    /// Format a language or currency code to human readable string.
    /// - Parameters:
    ///  - code: Optional String
    /// - Returns: String
    func formatCodeToName(from code: String?, type: ListDataType) -> String {
        guard let code = code else { return "" }
        guard let currentIdentifier = Locale.preferredLanguages.first else { return "" }
        let localeFromCurrentIdentifier = Locale(identifier: currentIdentifier)
        switch type {
        case .languages:
            return localeFromCurrentIdentifier.localizedString(forLanguageCode: code) ?? ""
        case .currency:
            return localeFromCurrentIdentifier.localizedString(forCurrencyCode: code) ?? ""
        }
    }
}
