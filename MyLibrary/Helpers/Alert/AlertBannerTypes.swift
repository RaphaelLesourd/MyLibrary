//
//  AlertBannerTypes.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

enum AlertBannerType {
    case error
    case success
    case customMessage(String)
    
    var message: String {
        switch self {
        case .error:
            return Text.Banner.errorTitle
        case .success:
            return Text.Banner.successTitle
        case .customMessage(let message):
            return message
        }
    }
}
