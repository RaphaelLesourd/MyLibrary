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
    case nothingFound
    case noBookTitle
    case firebaseError(Error)
   
    var description: String {
        switch self {
        case .passwordMismatch:
            return "Les mots de passe ne correspondent pas."
        case .noUserName:
            return "Le nom d'utilisateur ne peux être vide."
        case .nothingFound:
            return "Je n'ai rien trouvé."
        case .firebaseError(let error):
            return error.localizedDescription
        case .noBookTitle:
            return "Vous devez au moins entrer un titre."
        }
    }
}
