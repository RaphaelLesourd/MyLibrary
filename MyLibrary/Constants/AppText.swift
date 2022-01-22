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
        static let newCategoryTitle = NSLocalizedString("NewCategoryTitle", comment: "New Category Title")
        static let newCategorySubtitle = NSLocalizedString("NewCategorySubtitle", comment: "New Category Subtitle")
        static let editCategoryTitle = NSLocalizedString("EditCategoryTitle", comment: "New Category Title")
        static let editCategorySubtitle = NSLocalizedString("EditCategorySubtitle", comment: "New Category Subtitle")
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
        static let pastComment = NSLocalizedString("PastComments", comment: "past comments")
        static let categoryColor = NSLocalizedString("CategoryColorSectionTitle", comment: "Category Color Title")
        static let categoryListSectionHeader = NSLocalizedString("CategoryListSectionHeader",
                                                                 comment: "categoryList Sectionv Header")
        static let categoryListSectionFooter = NSLocalizedString("CategoryListSectionFooter",
                                                                 comment: "category List Section footer")
        static let newBookCategoriesHeader = NSLocalizedString("NewBookCategoriesHeader", comment: "new Book Categories Header")
        static let newBookPublishingHeader = NSLocalizedString("NewBookPublishingHeader", comment: "new Book Publishing Header")
        static let newBookDetailsHeader = NSLocalizedString("NewBookDetailsHeader", comment: "new Book Details Header")
        static let newBookRatingHeader = NSLocalizedString("NewBookRatingHeader", comment: "new Book Rating Header")
        static let newBookPriceHeader = NSLocalizedString("NewBookPriceHeader", comment: "new Book Price Header")
        static let newBookSaveFooter = NSLocalizedString("NewBookSaveFooter", comment: "new Book Save Footer")
        static let searchHeader = NSLocalizedString("SearchHeaderTitle", comment: "Search book header title")
        static let updateUserNameLegend = NSLocalizedString("UpdateUserNameLegend", comment: "Update UserName Legend text")
        static let languageListHeader = NSLocalizedString("LanguageListHeader", comment: "language List Header title")
        static let currencyListHeader = NSLocalizedString("CurrencyListHeader", comment: "currency List Header title")
    }
    
    enum ButtonTitle {
        static let createProfileButtonTitle = NSLocalizedString("CreateProfile", comment: "create profile title")
        static let save = NSLocalizedString("Save", comment: "save title")
        static let update = NSLocalizedString("Update", comment: "update title")
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
        static let done = NSLocalizedString("Done", comment: "done titletoday")
        static let letsGo = NSLocalizedString("Letsgo", comment: "go to a controller")
        static let deleteNewBookInfos = NSLocalizedString("DeleteNewBookInfos", comment: "delete new book info title")
        static let next = NSLocalizedString("Next", comment: "Next title")
        static let skip = NSLocalizedString("Skip", comment: "Skip title")
        static let close = NSLocalizedString("Close", comment: "close title")
    }
    
    enum Placeholder {
        static let search = NSLocalizedString("Search", comment: "search bar title")
        static let categoryName = NSLocalizedString("CategoryName", comment: "category name place holder")
        static let commentEntry = NSLocalizedString("CommentEntry", comment: "comment entry placeholder")
        static let commentEmptyState = NSLocalizedString("CommentEmptyState", comment: "No comments message")
    }
    
    enum Alert {
        static let signout = NSLocalizedString("AlertSignOutMessage", comment: "signout alert message")
        static let deleteAccountTitle = NSLocalizedString("AlertDeleteAccountTitle", comment: "delete account title")
        static let deleteAccountMessage = NSLocalizedString("AlertDeleteAccountMessage", comment: "auth message")
        static let descriptionChangedTitle = NSLocalizedString("Description", comment: "description title")
        static let descriptionChangedMessage = NSLocalizedString("AlertDescriptionChangedMessage",
                                                                 comment: "description change message")
        static let forgotPasswordTitle = NSLocalizedString("AlertPasswordForgottenTitle",  comment: "Password forgotten title")
        static let forgotPasswordMessage = NSLocalizedString("AlertPasswordForgottenMessage", comment: "Reset password message")
        static let deleteBookTitle = NSLocalizedString("AlertDeleteBookTitle",  comment: "delete book title")
        static let deleteBookMessage = NSLocalizedString("AlertDeleteBookMessage",  comment: "delete book message")
        static let cameraUnavailableTitle = NSLocalizedString("AlertCameraUnavailableTitle", comment: "Camera unavailable title")
        static let cameraUnavailableMessage = NSLocalizedString("AlertCameraUnavailableMessage",
                                                                comment: "Camera unavailable message")
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
        static let flashLightErrorMessage = NSLocalizedString("flashLightErrorMessage", comment: "flashLight Error Message")
      
        static let passwordMissmatch = NSLocalizedString("PasswordMissmatch", comment: "Password missmatch")
        static let usernameEmpty = NSLocalizedString("UsernameEmpty", comment: "Username can't be empty.")
        static let titleMissing = NSLocalizedString("TitleMissing", comment: "Title can't be empty.")
        static let categoryNotFound = NSLocalizedString("CategoryNotFound", comment: "Catagory not found.")
        static let categoryExist = NSLocalizedString("CategoryExist", comment: "This catagory already exist.")
        static let noNetwork = NSLocalizedString("NoNetwork", comment: "You seem to be offline.")
        static let notFound = NSLocalizedString("NotFound", comment: "Not found")
        static let emptyComment = NSLocalizedString("EmptyComment", comment: "Comment can't be empty.")
        static let bookExist = NSLocalizedString("BookExist", comment: "This book already exist.")
        static let requestCancelled = NSLocalizedString("RequestCancelled", comment: "RequestCancelled.")
        static let emailPasswordMismatch = NSLocalizedString("EmailPasswordNotFound", comment: "Email and password missmatch.")
        static let emailExist = NSLocalizedString("EmailExist", comment: "Email already in use.")
        
        static let invalidRequest = NSLocalizedString("InvalidRequest", comment: "Invalid request")
        static let invalidEmail = NSLocalizedString("InvalidPassword", comment: "Invalid password")
        static let invalidPassword = NSLocalizedString("InvalidEmail", comment: "Invalid email")
        static let accountDontExist = NSLocalizedString("AccountDontExist", comment: "No account exist with this email.")
        static let noText = NSLocalizedString("NoText", comment: "When textfield is empty")
        static let emptyQuery = NSLocalizedString("EmptyQuery", comment: "Query is empty")
        static let forbiden = NSLocalizedString("Forbidden", comment: "Http error 403")
        static let tooManyRequests = NSLocalizedString("TooManyRequests", comment: "Http error 429")
        static let internalServerError = NSLocalizedString("InternalServerError", comment: "Http error 500")
        static let serviceUnavailable = NSLocalizedString("ServiceUnavailable", comment: "Http error 503")
        static let unknownError = NSLocalizedString("UnknowError", comment: "Http all other error")
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
        static let extraLarge = NSLocalizedString("XLarge", comment: "Xlarge size title")
        static let large = NSLocalizedString("Large", comment: "large size title")
        static let medium = NSLocalizedString("Medium", comment: "medium size title")
        static let small = NSLocalizedString("Small", comment: "small size title")
        static let xsmall = NSLocalizedString("Xsmall", comment: "xsmall size title")
    }
    
    enum EmptyState {
        static let noBookTitle = NSLocalizedString("EmptyStateNoBookTitle", comment: "")
        static let noBookSubtitle = NSLocalizedString("EmptyStateNoBookSubtitle", comment: "")
        static let searchTitle = NSLocalizedString("EmptyStateSearchTitle", comment: "")
        static let searchSubtitle = NSLocalizedString("EmptyStateSearchSubtitle", comment: "")
        static let categoryTitle = NSLocalizedString("EmptyStateCategoryTitle", comment: "")
        static let categorySubtitle = NSLocalizedString("EmptyStateCategorySubtitle", comment: "")
        static let commentTitle = NSLocalizedString("EmptyStateCommentTitle", comment: "")
        static let commentSubtitle = NSLocalizedString("EmptyStateCommentSubtitle", comment: "")
    }
    
    enum Onboarding {
        static let referenceBookTitle = NSLocalizedString("referenceBookTitle", comment: "")
        static let referenceBookSubtitle = NSLocalizedString("referenceBookSubtitle", comment: "")
        static let searchBookTitle = NSLocalizedString("searchBookTitle", comment: "")
        static let searchBookSubtitle = NSLocalizedString("searchBookSubtitle", comment: "")
        static let shareBookTitle = NSLocalizedString("shareBookTitle", comment: "")
        static let shareBookSubtitle = NSLocalizedString("shareBookSubtitle", comment: "")
    }
}
