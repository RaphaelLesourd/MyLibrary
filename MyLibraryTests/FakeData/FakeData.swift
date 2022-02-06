//
//  FakeData.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 30/10/2021.
//
import Foundation
@testable import MyLibrary

class FakeData {
  // MARK Message
    static let correctMessageToPost = MessageModel(title: "Title",
                                                   body: "Body",
                                                   bookID: "1",
                                                   ownerID: "1",
                                                   imageURL: "",
                                                   token: "AAAABBBCCCCDDDD")

    // MARK: User
    static  let user: UserModelDTO = UserModelDTO(id: "1",
                                                  userID: "1",
                                                  displayName: "TestName",
                                                  email: "TestEmail",
                                                  photoURL: "PhotoURL",
                                                  token: "testToken")
    static let users: [UserModelDTO] = [UserModelDTO(id: "1",
                                                     userID: "1",
                                                     displayName: "TestUser",
                                                     email: "TestEmail",
                                                     photoURL: "testUrl",
                                                     token: "TestToken")]

    // MARK: Book
    private static let volumeInfo = VolumeInfo(title: "Tintin, Hergé et les autos",
                                               authors: [""],
                                               publisher: "",
                                               publishedDate: "",
                                               volumeInfoDescription: "",
                                               industryIdentifiers: [IndustryIdentifier(identifier: "")],
                                               pageCount: 0,
                                               ratingsCount: 0,
                                               imageLinks: ImageLinks(thumbnail: ""),
                                               language: "")
    private static let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: 0.0, currencyCode: ""))

    static let books: [ItemDTO] = [ItemDTO(id: "testID",
                                           bookID: "1",
                                           favorite: true,
                                           ownerID: "1",
                                           recommanding: true,
                                           volumeInfo: FakeData.volumeInfo,
                                           saleInfo: FakeData.saleInfo,
                                           timestamp: 0,
                                           category: [])]


    static let book: ItemDTO = ItemDTO(id: "testID",
                                       bookID: "1",
                                       favorite: true,
                                       ownerID: "1",
                                       recommanding: true,
                                       volumeInfo: FakeData.volumeInfo,
                                       saleInfo: FakeData.saleInfo,
                                       timestamp: 0,
                                       category: [])
    static let bookNilBookData: ItemDTO = ItemDTO(id: "1",
                                                  bookID: "1",
                                                  favorite: true,
                                                  ownerID: nil,
                                                  recommanding: true,
                                                  volumeInfo: FakeData.volumeInfo,
                                                  saleInfo: FakeData.saleInfo,
                                                  timestamp: 0,
                                                  category: [])

    static let bookCategoriesNil: ItemDTO = ItemDTO(id: "testID",
                                                    bookID: "1",
                                                    favorite: true,
                                                    ownerID: "1",
                                                    recommanding: true,
                                                    volumeInfo: FakeData.volumeInfo,
                                                    saleInfo: FakeData.saleInfo,
                                                    timestamp: 0,
                                                    category: nil)

    static let bookIncorrectData = "incorrectData".data(using: .utf8)!

    static var bookCorrectData: Data? {
        let bundle = Bundle(for: FakeData.self)
        let url = bundle.url(forResource: "BookFakeData", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var bookEmptyCorrectData: Data? {
        let bundle = Bundle(for: FakeData.self)
        let url = bundle.url(forResource: "BookEmptyFakeData", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    // MARK: Category
    static let category = CategoryDTO(id: "1", uid: "1", name: "test", color: "238099")

    static let categories: [CategoryDTO] = [CategoryDTO(id: "1",
                                                        uid: "1",
                                                        name: "First",
                                                        color: "238099"),
                                            CategoryDTO(id: "2",
                                                        uid: "2",
                                                        name: "Second",
                                                        color: "238099")]
    // MARK: Comment
    static let comment = CommentDTO(id: "1",
                                    uid: "1",
                                    userID: "1",
                                    userName: "name",
                                    userPhotoURL: "",
                                    message: "test",
                                    timestamp: 10000)

    static let commentList = [ CommentDTO(id: "1",
                                          uid: "1",
                                          userID: "1",
                                          userName: "name",
                                          userPhotoURL: "",
                                          message: "test",
                                          timestamp: 10000),
                               CommentDTO(id: "2",
                                          uid: "2",
                                          userID: "2",
                                          userName: "name2",
                                          userPhotoURL: "",
                                          message: "test2",
                                          timestamp: 10001)]

    // MARK: Query
    static let bookQuery = BookQuery(listType: HomeCollectionViewSections.favorites,
                                     orderedBy: .title,
                                     fieldValue: "",
                                     descending: true)

    static let bookQueryByCategory = BookQuery(listType: HomeCollectionViewSections.favorites,
                                               orderedBy: .category,
                                               fieldValue: "",
                                               descending: true)

    static let listData = DataList(title: "test",
                                   subtitle: "XUA",
                                   favorite: true)

    // MARK: Account
   static let accountCredentials = AccountCredentials(userName: "testuser",
                                                 email: "test@test.com",
                                                 password: "Test21@",
                                                 confirmPassword: "Test21@")

    static let accountCredentialsPassWordMismatch = AccountCredentials(userName: "testuser",
                                                  email: "test@test.com",
                                                  password: "Test21@",
                                                  confirmPassword: "Test")

    // MARK: Errors

    class ApiError: Error {}
    static let error = ApiError()

    enum PresenterError: Swift.Error {
        typealias RawValue = NSError
        case fail
    }
}
