//
//  AppText.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/10/2021.
//
import Foundation

enum Text {
    
    enum Account {
        static let loginTitle = NSLocalizedString("LoginTitle", comment: "log in title")
        static let loginSubtitle = NSLocalizedString("LoginSubtitle", comment: "log in message")
        static let loginButtonTitle = NSLocalizedString("LoginTitle", comment: "log in title")
        static let signupTitle = NSLocalizedString("SignupTitle", comment: "sign up title")
        static let signupSubtitle = NSLocalizedString("SignupSubtitle", comment: "password setup message")
        static let signupButtonTitle = NSLocalizedString("SignupTitle", comment: "sign up title")
        static let email = NSLocalizedString("Email", comment: "email placeholder")
        static let password = NSLocalizedString("Password", comment: "password placeholder")
        static let confirmPassword = NSLocalizedString("ConfirmPassword", comment: "Re enter password placeholder")
        static let forgotPassword = NSLocalizedString("ForgotPassword", comment: "forgotpassword title")
        static let welcomeMessage = NSLocalizedString("WelcomeMessage", comment: "Welcome message")
        static let userName = NSLocalizedString("Username", comment: "username title")
        static let reAuthentificationMessage = NSLocalizedString("ReAuthentificationMessage", comment: "Re authentification message")
    }
   
    enum ControllerTitle {
        static let newBook = NSLocalizedString("Newbook", comment: "new book title")
        static let home =  NSLocalizedString("Home", comment: "home title")
        static let myBooks = NSLocalizedString("Mybooks", comment: "my book title")
        static let search = NSLocalizedString("Search", comment: "search title")
        static let account = NSLocalizedString("Account", comment: "account title")
        static let profile = NSLocalizedString("Profile", comment: "profile title")
        static let category = NSLocalizedString("Categories", comment: "categories title")
        static let modify = NSLocalizedString("Modifybook", comment: "modify title")
        static let comments = NSLocalizedString("Comments", comment: "comments title")
        static let description = NSLocalizedString("Description", comment: "description title")
        static let barcodeController = NSLocalizedString("BarcodeControllerTitle", comment: "Barcode Controller Title")
        static let barcodeControllerSubitle = NSLocalizedString("BarcodeControllerSubitle", comment: "Barcode Controller Subitle")
        static let acknowledgements = NSLocalizedString("Acknowledgments", comment: "Acknoledgements title")
    }
    
    enum Book {
        static let bookName = NSLocalizedString("BookTitle", comment: "book title")
        static let authorName = NSLocalizedString("AuthorName", comment: "Author name")
        static let bookCategories = NSLocalizedString("Categories", comment: "categories title")
        static let publisher = NSLocalizedString("Publisher", comment: "publisher")
        static let publishedDate = NSLocalizedString("PublishedDate", comment: "published date")
        static let isbn = NSLocalizedString("ISBN", comment: "isbn book code title")
        static let numberOfPages = NSLocalizedString("Pages", comment: "number of pages")
        static let bookLanguage = NSLocalizedString("Language", comment: "language title")
        static let bookDescription = NSLocalizedString("Description", comment: "description title")
        static let comment = NSLocalizedString("UserComments", comment: "comments title")
        static let price = NSLocalizedString("Price", comment: "pricetitle")
        static let currency = NSLocalizedString("Currency", comment: "currency title")
        static let rating = NSLocalizedString("Rating", comment: "rating title")
        static let bookSaved = NSLocalizedString("BookSaved", comment: "book saved title")
        static let recommendedBy = NSLocalizedString("RecommendedBy", comment: "recommended by title text")
   }
    
    enum SectionTitle {
        static let latestBook = NSLocalizedString("LatestBooks", comment: "latest book title")
        static let favoritetBook = NSLocalizedString("FavoriteBooks", comment: "book title")
        static let userRecommandation = NSLocalizedString("Recommendations", comment: "book title")
        static let readersComment = NSLocalizedString("ReaderComments", comment: "reader's comment view title")
        static let todayComment = NSLocalizedString("Today", comment: "today's comments")
    }
    
    enum ButtonTitle {
        static let createProfileButtonTitle = NSLocalizedString("CreateProfile", comment: "create profile title")
        static let save = NSLocalizedString("Save", comment: "save title")
        static let signOut = NSLocalizedString("SignOut", comment: "sign out title")
        static let deletaAccount = NSLocalizedString("DeleteAccount", comment: "delete account title")
        static let delete = NSLocalizedString("Delete", comment: "delete title")
        static let edit = NSLocalizedString("Edit", comment: "edit title")
        static let seeAll = NSLocalizedString("SeeAll", comment: "book title")
        static let manage = NSLocalizedString("Manage", comment: "book title")
        static let recommend = NSLocalizedString("Recommend", comment: "recommend book title")
        static let stopRecommending = NSLocalizedString("StopRecommending", comment: "stop recommend book title")
        static let add = NSLocalizedString("Add", comment: "add button title")
        static let modify = NSLocalizedString("Modify", comment: "modify button title")
        static let okTitle = NSLocalizedString("OK", comment: "ok button title")
        static let cancel = NSLocalizedString("Cancel", comment: "Cancel button title")
        static let deleteBook = NSLocalizedString("DeleteThisBook", comment: "delete book title")
        static let contactUs = NSLocalizedString("ContactUs", comment: "contact title")
        static let camera = NSLocalizedString("TakePhoto", comment: "camera title")
        static let cameraRoll = NSLocalizedString("CameraRoll", comment: "camera roll title")
        static let photoLibrary = NSLocalizedString("PhotoLibrary", comment: "photo library title")
    }
    
    enum Placeholder {
        static let search = NSLocalizedString("Search", comment: "search bar title")
        static let homeControllerEmptyState = NSLocalizedString("HomeControllerEmptyState", comment: "home controller empty state message")
        static let bookListEmptyState = NSLocalizedString("BookListEmptyState", comment: "books empty state message")
        static let searchListEmptyState = NSLocalizedString("SearchListEmptyState", comment: "search empty state message")
        static let categoryName = NSLocalizedString("CategoryName", comment: "category name place holder")
        static let commentEntry = NSLocalizedString("CommentEntry", comment: "comment entry placeholder")
        static let commentEmptyState = NSLocalizedString("CommentEmptyState", comment: "No comments message")
    }
  
    enum Alert {
        static let signout = NSLocalizedString("AlertSignOutMessage", comment: "signout alert message")
        static let deleteAccountTitle = NSLocalizedString("AlertDeleteAccountTitle", comment: "delete account title")
        static let deleteAccountMessage = NSLocalizedString("AlertDeleteAccountMessage", comment: "auth message")
        static let descriptionChangedTitle = NSLocalizedString("Description", comment: "description title")
        static let descriptionChangedMessage = NSLocalizedString("AlertDescriptionChangedMessage", comment: "description change message")
        static let forgotPasswordTitle = NSLocalizedString("AlertPasswordForgottenTitle",  comment: "Password forgotten title")
        static let forgotPasswordMessage = NSLocalizedString("AlertPasswordForgottenMessage", comment: "Reset password message")
        static let deleteBookTitle = NSLocalizedString("AlertDeleteBookTitle",  comment: "delete book title")
        static let deleteBookMessage = NSLocalizedString("AlertDeleteBookMessage",  comment: "delete book message")
        static let cameraUnavailableTitle = NSLocalizedString("AlertCameraUnavailableTitle", comment: "Camera unavailable title")
        static let cameraUnavailableMessage = NSLocalizedString("AlertCameraUnavailableMessage", comment: "Camera unavailable message")
        static let newCategoryTitle = NSLocalizedString("AlertNewCategoryTitle", comment: "new category title")
        static let newCategoryMessage = NSLocalizedString("AlertNewCategoryMessage", comment: "new category message")
        static let deleteCategoryMessage = NSLocalizedString("AlertDeleteCategoryMessage", comment: "delete category message")
    }

    enum Banner {
        static let seeYouSoon = NSLocalizedString("GoodByeMessage", comment: "Goodbye message")
        static let profilePhotoUpdated = NSLocalizedString("ProfilePhotoUpdated", comment: "profile photo updted message")
        static let userNameUpdated = NSLocalizedString("UsernameUpdated", comment: "username updated message")
        static let errorTitle = NSLocalizedString("Error", comment: "Error title")
        static let successTitle = NSLocalizedString("Success", comment: "Success title")
        static let accountOpen = NSLocalizedString("AccountOpen", comment: "account open title")
        static let emptyEmail = NSLocalizedString("EmptyEmail", comment: "empty email title")
        static let unsentEmail = NSLocalizedString("UnsentEmail", comment: "email is not sent")
        static let sentEmail = NSLocalizedString("SentEmail", comment: "email is sent")
        static let resetPassordTitle = NSLocalizedString("ResetPassword", comment: "reset password title")
        static let resetPasswordMessage = NSLocalizedString("ReauthentifyBannerMessage", comment: "re authentify subtitle")
        static let accountDeleted = NSLocalizedString("AccountDeleted", comment: "account deleted title")
        static let bookDeleted = NSLocalizedString("BookDeleted", comment: "book deleted title")
        static let cameraPermissionsTitle = NSLocalizedString("Permissions",  comment: "camer aPermissions Title")
        static let cameraPermissionsMessage = NSLocalizedString("CameraPermissionsMessage", comment: "camera Permissions Message")
        static let categoryAddedTitle = NSLocalizedString("CategoryAdded", comment: "category Added Title")
        static let categoryModfiedTitle = NSLocalizedString("CategoryModified", comment: "category Modfied Title")
        static let unableToOpenMailAppTitle = NSLocalizedString("UnableToOpenMailApp", comment: "unable to open mail Title")
        static let feedbackSentTitle = NSLocalizedString("FeedbackSent", comment: "feedback sent Title")
        static let accessNotAuthorizedMessage = NSLocalizedString("AccessNotAuthorized", comment: "access not authorized message")
        static let welcomeTitle = NSLocalizedString("Welcome", comment: "welcome title")
        static let noFlashLightTitle = NSLocalizedString("NoFlashlightTitle", comment: "flash light unavailable")
    }
    
    enum Misc {
        static let reloading = NSLocalizedString("Reloading", comment: "Reloading tableview message")
        static let informations = NSLocalizedString("Information", comment: "information in a title")
        static let appVersion = NSLocalizedString("Version", comment: "app version title")
        static let appBuild = NSLocalizedString("Build", comment: "app build number title")
        static let appCreationYear = NSLocalizedString("AppCreationYear", comment: "year app created title")
        static let notificationSaidComment = NSLocalizedString("said", comment: "said word when user said ...")
        static let closeKeyboardButton = NSLocalizedString("CloseKeyboard", comment: "Close keyboard button")
        static let unavailable = NSLocalizedString("Unavailable", comment: "when something not available")
    }
    
    enum ListMenu {
        static let bookListMenuTitle = NSLocalizedString("BookListMenuTitle", comment: "Book List Menu Title")
        static let byTimestamp = NSLocalizedString("ByTimestampList", comment: "By Timestamp menu list")
        static let byTitle = NSLocalizedString("ByTitleList", comment: "ByTitle menu list")
        static let byAuthor = NSLocalizedString("ByAuthorList", comment: "ByAuthor menu list")
        static let byRating = NSLocalizedString("ByRatingList", comment: "ByRating menu list")
        static let large = NSLocalizedString("Large", comment: "large size title")
        static let medium = NSLocalizedString("Medium", comment: "medium size title")
        static let small = NSLocalizedString("Small", comment: "small size title")
    }
}
