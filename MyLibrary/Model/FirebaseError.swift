//
//  UserError.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/11/2021.
//

import Foundation

enum FirebaseError: Error {
    case passwordMismatch
    case noUserName
    case firebaseError(Error)
   
    var description: String {
        switch self {
        case .passwordMismatch:
            return "Les mots de passes ne correspondent pas."
        case .noUserName:
            return "Le nom d'utilisateur ne peux être vide."
        case .firebaseError(let error):
            return error.localizedDescription
        }
    }
}
