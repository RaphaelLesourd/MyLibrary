//
//  Constants.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//
import Foundation
import UIKit

/// Type of Code type , used mainly by Pickers in the NewBookViewController
enum ListDataType: String {
    case languages
    case currency
    
    var code: [String] {
        switch self {
        case .languages:
            return Locale.isoLanguageCodes
        case .currency:
            return Locale.isoCurrencyCodes
        }
    }
    
    var title: String {
        switch self {
        case .languages:
            return Text.Book.bookLanguage
        case .currency:
            return Text.Book.currency
        }
    }
    
    var icon: UIImage {
        switch self {
        case .languages:
            return Images.ButtonIcon.language
        case .currency:
            return Images.ButtonIcon.currencies
        }
    }
}
