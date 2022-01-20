//
//  FormatterProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol FormatterProtocol {
    func formatDateToYearString(for dateString: String?) -> String
    func formatDoubleToPrice(with value: Double?, currencyCode: String?) -> String
    func formatCodeToName(from code: String?, type: CodeType) -> String
    func formatTimeStampToRelativeDate(for timestamp: Double?) -> String
}
