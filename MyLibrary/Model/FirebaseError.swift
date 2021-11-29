//
//  UserError.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/11/2021.
//

import Foundation
import Firebase
import FirebaseAuth

enum FirebaseError: Error {
  
    case passwordMismatch
    case noUserName
    case noCategory
    case categoryExist
    case noBookTitle
    case noNetwork
    case nothingFound
    case firebaseError(Error)
    case firebaseAuthError(Error)
   
    var description: String {
        switch self {
        case .passwordMismatch:
            return "Les mots de passe ne correspondent pas."
        case .noUserName:
            return "Le nom d'utilisateur ne peux être vide."
        case .noBookTitle:
            return "Vous devez au moins entrer un titre."
        case .noCategory:
            return "Le nom ne peux être vide."
        case .categoryExist:
            return "Cette catégorie existe déja."
        case .noNetwork:
            return "Vous semblez être hors ligne."
        case .firebaseError(let error):
            return getFirestoreError(for: error)
        case .firebaseAuthError(let error):
            return getAuthError(for: error)
        case .nothingFound:
            return "Introuvable"
        }
    }
    
    func getFirestoreError(for error: Error) -> String {
        let errorCode = FirestoreErrorCode(rawValue: error._code)
        switch errorCode {
        case .alreadyExists:
            return "Ce livre existe déja."
        case .aborted:
            return "Demande intérompue."
        case .invalidArgument:
            return "Requette non valable."
        case .notFound:
            return "Livre non trouvable."
        case .unavailable:
            return "Livre non disponible."
        case .some(_), .none:
            return error.localizedDescription
        }
    }
    
    func getAuthError(for error: Error) -> String {
        let errorCode = AuthErrorCode(rawValue: error._code)
        switch errorCode {
        case .accountExistsWithDifferentCredential:
            return "L'email et le mot de passe ne correspondent pas."
        case .emailAlreadyInUse:
            return "Email déja utilisé."
        case .invalidEmail:
            return "Mauvaise email."
        case .wrongPassword:
            return "Mauvais mot de passe."
        case .invalidRecipientEmail:
            return "Aucuns compte existe avec cet email."
        case .some(_), .none:
            return error.localizedDescription
        }
    }
}
