//
//  Validation.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol ValidationProtocol {
    func validateEmail(_ email: String?) -> Bool
    func validatePassword(_ password: String?) -> Bool
    func validateIsbn(_ value: String) -> Bool
    func validateTimestamp(for timestamp: Double?) -> Double
    func isTimestampToday(for timestamp: Double?) -> Bool
}
