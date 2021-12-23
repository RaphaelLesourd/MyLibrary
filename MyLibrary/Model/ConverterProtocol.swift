//
//  ConverterProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol ConverterProtocol {
    func convertArrayToString(_ dataArray: [String]?) -> String
    func convertStringToInt(_ value: String?) -> Int
    func convertStringToDouble(_ value: String?) -> Double
}
