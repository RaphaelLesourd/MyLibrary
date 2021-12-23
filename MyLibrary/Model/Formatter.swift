//
//  Converter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/11/2021.
//

import Foundation

class Formatter: FormatterProtocol {
    /// Format a timeStamp to a time ago string.
    /// - Parameter timestamp: Otional Double
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
    ///  - Parameter dateString: Optional String
    ///  - Returns: Four digits Year String
    ///  - Note: For example 2021-12-12 to 2021. Uses "yyyy-MM-dd" as input formatter as the API provides only this type odf date format.
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
    /// Format a price
    /// - Note: We can safely force-unwrap the optional that NumberFormatter returns from the call,
    /// since we’re in complete control over the NSNumber that is being passed into it.
    /// - Parameter currencyCode: 3 letters currency code (ie: EUR, USD etc)
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
    /// - Parameter code: Optional String
    /// - Returns: String
    func formatCodeToName(from code: String?, type: CodeType) -> String {
        guard let code = code,
              let currentIdentifier = Locale.current.regionCode else { return "" }
        let localeFromCurrentIdentifier = Locale(identifier: currentIdentifier)
        switch type {
        case .language:
            return localeFromCurrentIdentifier.localizedString(forLanguageCode: code) ?? ""
        case .currency:
            return localeFromCurrentIdentifier.localizedString(forCurrencyCode: code) ?? ""
        }
    }
}
