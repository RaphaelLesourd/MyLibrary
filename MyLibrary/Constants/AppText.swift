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
        static let loginSubtitle = "Veuillez entrer votre email et votre mot de passe pour vous connecter à votre compte."
        static let loginButtonTitle =  "Se connecter"
        static let signupTitle = "Inscription"
        static let signupSubtitle = "Choisissez un mot de passe avec minimum 1 chiffre, un charactère spécial et minimum 6 lettres."
        static let signupButtonTitle = "S'inscrire"
        static let email = "Email"
        static let password = "Mot de passe"
        static let confirmPassword = "Confirmez votre mot de passe"
        static let forgotPassword = "Mot de passe oublié"
        static let welcomeMessage = "Bienvenue\ndans votre\nbibliothèque."
        static let termOfUseMessage = "Conditions d'utilisation"
        static let otherConnectionTypeMessage = "Autres moyens de se connecter"
    }
    
    enum Profile {
        static let userName = "Nom d'utilisateur"
        static let createProfileButtonTitle = "Créer un profil"
    }
    
    enum ControllerTitle {
        static let newBook = "Nouveau livre"
        static let home = "Accueil"
        static let myBooks = "Mes livres"
        static let search = "Recherche"
        static let settings = "Réglages"
        static let profile = "Profil"
        static let category = "Catégories"
        static let modify = "Modifier"
    }
    
    enum Book {
        static let bookName = "Titre du livre"
        static let authorName = "Nom de l'auteur"
        static let bookCategories = "Catégories"
        static let publisher = "Editeur"
        static let publishedDate = "Date de parution"
        static let isbn = "ISBN "
        static let numberOfPages = "Nombre de pages"
        static let bookLanguage = "Langue du livre"
        static let bookDescription = "Description"
        static let price = "Prix d'achat"
        static let resellPrice = "Côte actuelle"
        static let rating = "Note\n(0 à 5)"
        static let bookSaved = "Livre enregistré."
    }
    
    enum ButtonTitle {
        static let save = "Enregistrer"
        static let signOut = "Déconnexion"
        static let deletaAccount = "Supprimer le compte"
    }
    
    enum SearchBarPlaceholder {
        static let search = "Rechercher"
    }
}
