//
//  AppText.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/10/2021.
//

import Foundation

enum Text {
    
    enum Account {
        static let loginTitle = "Connexion"
        static let loginSubtitle = "Veuillez entrer votre email et votre mot de passe\npour vous connecter à votre compte."
        static let loginButtonTitle =  "Se connecter"
        static let signupTitle = "Inscription"
        static let signupSubtitle = "Choisissez un mot de passe avec minimum 1 chiffre,\nun charactère spécial et minimum 6 lettres."
        static let signupButtonTitle = "S'inscrire"
        static let email = "Email"
        static let password = "Mot de passe"
        static let confirmPassword = "Confirmez votre mot de passe"
        static let forgotPassword = "Mot de passe oublié"
        static let welcomeMessage = "Bienvenue\ndans votre\nbibliothèque."
        static let termOfUseMessage = "Conditions d'utilisation"
        static let otherConnectionTypeMessage = "Autres moyens de se connecter:"
    }
    
    enum Profile {
        static let userName = "Nom d'utilisateur"
        static let createProfileButtonTitle = "Créer un profil"
    }
    
    enum ControllerTitle {
        static let newBook = "Nouveau livre"
        static let home = "Acceuil"
        static let myBooks = "Mes livres"
        static let search = "Chercher"
        static let settings = "Réglages"
        static let profile = "Profil"
    }
}
