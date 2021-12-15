//
//  AppText.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/10/2021.
//
import Foundation

enum Text {
    
    enum Account {
        static let loginTitle = NSLocalizedString("Log in", comment: "log in title")
        static let loginSubtitle = NSLocalizedString("Enter you email and password to log in", comment: "log in message")
        static let loginButtonTitle = NSLocalizedString("Log in", comment: "log in title")
        static let signupTitle = NSLocalizedString("Sign up", comment: "sign up title")
        static let signupSubtitle = NSLocalizedString("Choose a password with at least 1 number, a special character and minimum 6 letters.",
                                                      comment: "password setup message")
        static let signupButtonTitle = NSLocalizedString("Sign up", comment: "sign up title")
        static let email = NSLocalizedString("Email", comment: "email placeholder")
        static let password = NSLocalizedString("Password", comment: "password placeholder")
        static let confirmPassword = NSLocalizedString("Re-enter password", comment: "Re enter password placeholder")
        static let forgotPassword = NSLocalizedString("Forgot password", comment: "forgotpassword title")
        static let welcomeMessage = NSLocalizedString("Welcome\nto your\nBook Library.", comment: "Welcome message")
        static let userName = NSLocalizedString("Username", comment: "username title")
        static let reAuthentificationMessage = NSLocalizedString("Please enter your email and password to re-authentify",
                                                                 comment: "Re authentification message")
    }
   
    enum ControllerTitle {
        static let newBook = NSLocalizedString("New book", comment: "new book title")
        static let home =  NSLocalizedString("Home", comment: "home title")
        static let myBooks = NSLocalizedString("My books", comment: "my book title")
        static let search = NSLocalizedString("Search", comment: "search title")
        static let account = NSLocalizedString("Account", comment: "account title")
        static let profile = NSLocalizedString("Profile", comment: "profile title")
        static let category = NSLocalizedString("Categories", comment: "categories title")
        static let modify = NSLocalizedString("Modify book", comment: "modify title")
        static let comments = NSLocalizedString("Comments", comment: "comments title")
        static let description = NSLocalizedString("Description", comment: "description title")
    }
    
    enum Book {
        static let bookName = NSLocalizedString("Book title", comment: "book title")
        static let authorName = NSLocalizedString("Author name", comment: "Author name")
        static let bookCategories = NSLocalizedString("Categories", comment: "categories title")
        static let publisher = NSLocalizedString("Publisher", comment: "publisher")
        static let publishedDate = NSLocalizedString("Published date", comment: "published date")
        static let isbn = NSLocalizedString("ISBN ", comment: "isbn book code title")
        static let numberOfPages = NSLocalizedString("Pages", comment: "number of pages")
        static let bookLanguage = NSLocalizedString("Language", comment: "language title")
        static let bookDescription = NSLocalizedString("Description", comment: "description title")
        static let comment = NSLocalizedString("User comments", comment: "comments title")
        static let price = NSLocalizedString("Price", comment: "pricetitle")
        static let currency = NSLocalizedString("Currency", comment: "currency title")
        static let rating = NSLocalizedString("Rating\n(0 to 5)", comment: "rating title")
        static let bookSaved = NSLocalizedString("Book saved", comment: "book saved title")
        static let recommendedBy = NSLocalizedString("Recommended by ", comment: "recommended by title text")
   }
    
    enum SectionTitle {
        static let latestBook = NSLocalizedString("Latest books", comment: "latest book title")
        static let favoritetBook = NSLocalizedString("Favorite books", comment: "book title")
        static let userRecommandation = NSLocalizedString("User recommandations", comment: "book title")
        static let readersComment = NSLocalizedString("Reader's comments", comment: "reader's comment view title")
        static let todayComment = NSLocalizedString("Today", comment: "today's comments")
    }
    
    enum ButtonTitle {
        static let createProfileButtonTitle = NSLocalizedString("Create profile", comment: "create profile title")
        static let save = NSLocalizedString("Save", comment: "save title")
        static let signOut = NSLocalizedString("Sign out", comment: "sign out title")
        static let deletaAccount = NSLocalizedString("Delete account", comment: "delete account title")
        static let delete = NSLocalizedString("Delete", comment: "delete title")
        static let edit = NSLocalizedString("Edit", comment: "edit title")
        static let seeAll = NSLocalizedString("See all", comment: "book title")
        static let manage = NSLocalizedString("Manage", comment: "book title")
        static let recommend = NSLocalizedString("Recommend", comment: "recommend book title")
        static let stopRecommending = NSLocalizedString("Stop recommending", comment: "stop recommend book title")
        static let add = NSLocalizedString("Add", comment: "add button title")
        static let modify = NSLocalizedString("Modify", comment: "modify button title")
        static let okTitle = NSLocalizedString("OK", comment: "ok button title")
        static let cancel = NSLocalizedString("Cancel", comment: "Cancel button title")
        static let deleteBook = NSLocalizedString("Delete this book", comment: "delete book title")
        static let contactUs = NSLocalizedString("Contact us", comment: "contact title")
        static let camera = NSLocalizedString("Take photo", comment: "camera title")
        static let cameraRoll = NSLocalizedString("Camera roll", comment: "camera roll title")
        static let photoLibrary = NSLocalizedString("Photo library", comment: "photo library title")
        static let large = NSLocalizedString("Large", comment: "large size title")
        static let medium = NSLocalizedString("Medium", comment: "medium size title")
        static let small = NSLocalizedString("Small", comment: "small size title")
    }
    
    enum Placeholder {
        static let search = NSLocalizedString("Search", comment: "search bar title")
        static let homeControllerEmptyState = NSLocalizedString("No books in your library yet", comment: "home controller empty state message")
        static let bookListEmptyState = NSLocalizedString("No books in ", comment: "books empty state message")
        static let searchListEmptyState = NSLocalizedString("Search here for book, comics, etc..", comment: "search empty state message")
        static let categoryName = NSLocalizedString("Category name", comment: "category name place holder")
        static let commentEntry = NSLocalizedString("Enter your thoughts...", comment: "comment entry placeholder")
        static let commentEmptyState = NSLocalizedString("Be the first one to leave a comment about this book...", comment: "No comments message")
        
    }
  
    enum Alert {
        static let signout = NSLocalizedString("Are you sure you want to sign out?", comment: "signout alert message")
        static let deleteAccountTitle = NSLocalizedString("Are you sure you want to delete your account?", comment: "delete account title")
        static let deleteAccountMessage = NSLocalizedString("You wil need to re-authentify.", comment: "auth message")
        static let descriptionChangedTitle = NSLocalizedString("Description", comment: "description title")
        static let descriptionChangedMessage = NSLocalizedString("The description of this book changed, would you lie to save those modifications?",
                                                                 comment: "description change message")
        static let forgotPasswordTitle = NSLocalizedString("Password forgotten",  comment: "Password forgotten title")
        static let forgotPasswordMessage = NSLocalizedString("Are you sure you would like to reset your password?",
                                                             comment: "Reset password message")
        static let deleteBookTitle = NSLocalizedString("Delete book",  comment: "delete book title")
        static let deleteBookMessage = NSLocalizedString("Are you sure you want to delete this book?",  comment: "delete book message")
        static let cameraUnavailableTitle = NSLocalizedString("Camera unavailable", comment: "Camera unavailable title")
        static let cameraUnavailableMessage = NSLocalizedString("It seems there is a problem with your camera.",
                                                                comment: "Camera unavailable message")
        static let newCategoryTitle = NSLocalizedString("New category", comment: "new category title")
        static let newCategoryMessage = NSLocalizedString("Add a new categry", comment: "new category message")
        static let deleteCategoryMessage = NSLocalizedString("Are you sure you want to delete this category?", comment: "delete category message")
    }

    enum Banner {
        static let seeYouSoon = NSLocalizedString("See you soon", comment: "Goodbye message")
        static let profilePhotoUpdated = NSLocalizedString("Photo de profil mise à jour.", comment: "profile photo updted message")
        static let userNameUpdated = NSLocalizedString("Username updated", comment: "username updated message")
        static let errorTitle = NSLocalizedString("Error", comment: "Error title")
        static let successTitle = NSLocalizedString("Success", comment: "Success title")
        static let accountOpen = NSLocalizedString("Account open", comment: "account open title")
        static let emptyEmail = NSLocalizedString("Empty email", comment: "empty email title")
        static let resetPassordTitle = NSLocalizedString("Reset password", comment: "reset password title")
        static let resetPasswordMessage = NSLocalizedString("Please re-authentify.", comment: "re authentify subtitle")
        static let accountDeleted = NSLocalizedString("Account Deleted", comment: "account deleted title")
        static let bookDeleted = NSLocalizedString("Book deleted from your library.", comment: "book deleted title")
        static let cameraPermissionsTitle = NSLocalizedString("Permissions",  comment: "camer aPermissions Title")
        static let cameraPermissionsMessage = NSLocalizedString("Please update your settings to allow the use of this device camera.",
                                                                comment: "camera Permissions Message")
        static let categoryAddedTitle = NSLocalizedString("Category added", comment: "category Added Title")
        static let categoryModfiedTitle = NSLocalizedString("Category modified", comment: "category Modfied Title")
        static let unableToOpenMailAppTitle = NSLocalizedString("Unable to open Mail", comment: "unable to open mail Title")
        static let feedbackSentTitle = NSLocalizedString("Feedback sent", comment: "feedback sent Title")
        static let accessNotAuthorizedMessage = NSLocalizedString("Access not authorized", comment: "access not authorized message")
    }
    
    enum Misc {
        static let reloading = NSLocalizedString("Reloading", comment: "Reloading tableview message")
        static let informations = NSLocalizedString("Information", comment: "information in a title")
        static let appVersion = NSLocalizedString("Version", comment: "app version title")
        static let appBuild = NSLocalizedString("Build", comment: "app build number title")
        static let appCreationYear = NSLocalizedString("Created in", comment: "year app created title")
        static let sizeMenuTitle = NSLocalizedString("View size", comment: "size menu title")
    }
}
