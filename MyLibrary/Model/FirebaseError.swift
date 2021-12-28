//
//  UserError.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/11/2021.
//

import Firebase
import FirebaseAuth

enum FirebaseError: Error {
  
    case passwordMismatch
    case noUserName
    case noCategory
    case categoryExist
    case noBookTitle
    case noComment
    case noNetwork
    case nothingFound
    case firebaseError(Error)
    case firebaseAuthError(Error)
   
    var description: String {
        switch self {
        case .passwordMismatch:
            return Text.Banner.passwordMissmatch
        case .noUserName:
            return Text.Banner.titleMissing
        case .noBookTitle:
            return Text.Banner.titleMissing
        case .noCategory:
            return Text.Banner.categoryNotFound
        case .categoryExist:
            return Text.Banner.categoryExist
        case .noNetwork:
            return Text.Banner.noNetwork
        case .firebaseError(let error):
            return getFirestoreError(for: error)
        case .firebaseAuthError(let error):
            return getAuthError(for: error)
        case .nothingFound:
            return Text.Banner.notFound
        case .noComment:
            return Text.Banner.emptyComment
        }
    }
    
    func getFirestoreError(for error: Error) -> String {
        let errorCode = FirestoreErrorCode(rawValue: error._code)
        switch errorCode {
        case .alreadyExists:
            return Text.Banner.bookExist
        case .aborted:
            return Text.Banner.requestCancelled
        case .invalidArgument:
            return Text.Banner.invalidRequest
        case .notFound:
            return Text.Banner.notFound
        case .unavailable:
            return Text.Misc.unavailable
        case .some(_), .none:
            return error.localizedDescription
        }
    }
    
    func getAuthError(for error: Error) -> String {
        let errorCode = AuthErrorCode(rawValue: error._code)
        switch errorCode {
        case .accountExistsWithDifferentCredential:
            return Text.Banner.emailPasswordMismatch
        case .emailAlreadyInUse:
            return Text.Banner.emailExist
        case .invalidEmail:
            return Text.Banner.invalidEmail
        case .wrongPassword:
            return Text.Banner.invalidPassword
        case .invalidRecipientEmail:
            return Text.Banner.accountDontExist
        case .some(_), .none:
            return error.localizedDescription
        }
    }
}
