//
//  Validator.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/11/2021.
//

import Foundation

class Validation: ValidationProtocol {
    
    func validateEmail(_ email: String?) -> Bool {
        guard let email = email, !email.isEmpty else {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    /// Validate password using predicate mathing a regex
    /// * At least 1 uppercase letter, 1 digits, one special character , 6 characters long
    /// -  ^    Start anchor
    /// - (?=.*[A-Z])   Ensure string has one uppercase letters.
    /// - (?=.*[d$@$!%*?&#])  Ensure string has one special case letter.
    /// - (?=.*[0-9].*[0-9])    Ensure string has two digits.
    /// - (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
    /// - .{6}    Ensure string is of length 6.
    /// - $    End anchor.
    /// - Returns: true or false if matches regex
    func validatePassword(_ password: String?) -> Bool {
        guard let password = password, !password.isEmpty else {
            return false
        }
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: password)
    }
    
    func validateIsbn(_ value: String) -> Bool {
        return (value.count >= 10) && value.allSatisfy { $0.isNumber }
    }
    
    func validateTimestamp(for timestamp: Double?) -> Double {
        return timestamp ?? Date().timeIntervalSince1970
    }
    
    func isTimestampToday(for timestamp: Double?) -> Bool {
        guard let timestamp = timestamp else {
            return false
        }
        let date = Date(timeIntervalSince1970: (timestamp))
        return Calendar.current.isDateInToday(date)
    }
}
