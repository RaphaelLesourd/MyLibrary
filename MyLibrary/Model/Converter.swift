//
//  Converter.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/12/2021.
//

import Foundation

class Converter: ConverterProtocol {
    /// Joins an Array of string into one single String
    /// - Parameter dataArray:  Optional Array of Strings
    /// - Returns: String
    func convertArrayToString(_ dataArray: [String]?) -> String {
        guard let dataArray = dataArray else {
            return ""
        }
        return dataArray.joined(separator: ", ")
    }
    /// Format a String to Double
    /// - Parameter value: Optional  String
    /// - Returns: Double
    func convertStringToDouble(_ value: String?) -> Double {
        guard let value = value?.replacingOccurrences(of: ",", with: ".") else {
            return 0
        }
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.decimalSeparator = "."
        return formatter.number(from: value)?.doubleValue ?? 0
    }
    
    /// Format a string to Int
    /// - Parameter value: Optional  String
    /// - Returns: Int
    func convertStringToInt(_ value: String?) -> Int {
        guard let value = value else {
            return 0
        }
        let formatter = NumberFormatter()
        return formatter.number(from: value)?.intValue ?? 0
    }
}
