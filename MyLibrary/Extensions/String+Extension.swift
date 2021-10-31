//
//  String+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import Foundation

extension String {
    
    // MARK: - Validation
    func validateEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    /// Validate password using predicate mathing a regex
    /// * At least 1 uppercase letter, 1 digits, one special character , 6 characters long
    /// -  ^    Start anchor
    /// - (?=.*[A-Z])   Ensure string has one uppercase letters.
    /// -  (?=.*[d$@$!%*?&#])  Ensure string has one special case letter.
    /// - (?=.*[0-9].*[0-9])    Ensure string has two digits.
    /// - (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
    /// - .{6}    Ensure string is of length 6.
    /// - $    End anchor.
    /// - Returns: true or false if matches regex
    func validatePassword() -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: self)
    }
    
    /// Return country name from country code in device language
    var languageName: String {
        let currentIdentifier = Locale.current.regionCode ?? ""
        let localeFromCurrentIdentifier = Locale(identifier: currentIdentifier)
        return localeFromCurrentIdentifier.localizedString(forLanguageCode: self) ?? ""
    }
    
    var currencySymbol: String {
        let locale = NSLocale(localeIdentifier: self)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: self) ?? ""
    }
    
    var displayYearOnly: String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        let date = inputDateFormatter.date(from: self) ?? Date()

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy"
        return outputDateFormatter.string(from: date)
    }
    
    var isIsbn: Bool {
         return (self.count >= 10 ) && self.allSatisfy { $0.isNumber }
       }
}
