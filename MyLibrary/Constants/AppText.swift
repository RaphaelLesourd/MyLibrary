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
        static let newBook = NSLocalizedString("Nouveau livre", comment: "new book title") // "Nouveau livre"
        static let home =  NSLocalizedString("Accueil", comment: "Welcome title")//
        static let myBooks = "Mes livres"
        static let search = "Recherche"
        static let account = "Compte"
        static let profile = "Profil"
        static let category = "Catégories"
        static let modify = "Modifier"
        static let comments = "Commentaires"
        static let description = "Description"
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
        static let comment = "Commentaires, avis..."
        static let price = "Prix d'achat"
        static let currency = "Monnaie"
        static let rating = "Note\n(0 à 5)"
        static let bookSaved = "Livre enregistré."
    }
    
    enum ButtonTitle {
        static let save = "Enregistrer"
        static let signOut = "Déconnexion"
        static let deletaAccount = "Supprimer le compte"
        static let delete = "Effacer"
        static let edit = "Editer"
    }
    
    enum SearchBarPlaceholder {
        static let search = "Rechercher"
    }
    
    enum Alert {
        static let noCommentsTitle = "Ajouter un commentaire"
        static let noCommentsMessage = "Il n'y a pas encore de commentaires pour ce livre. Voulez vous être le premier en ajouter un?"
        static let signout = "Etes-vous sûr de vouloir vous déconnecter."
        static let deleteAccountTitle = "Etes-vous sûr de vouloir supprimer votre compte?"
        static let deleteAccountMessage = "Vous allez devoir vous re-authentifier."
        static let descriptionChangedTitle = "Description"
        static let descriptionChangedMessage = "Vous avez modifié la description, voulez-vous grader ces modifications?"
    }
    
    enum Banner {
        static let seeYouSoon = "A bientôt!"
        static let profilePhotoUpdated = "Photo de profil mise à jour."
        static let userNameUpdated = "Nom d'utilisateur mis à jour."
        static let errorTitle = "Erreur!"
        static let successTitle = "Succés"
    }
}
