//
//  FakeData.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import Foundation
@testable import MyLibrary

class PresenterFakeData {
    
    static  let user: UserModel = UserModel(id: "",
                                            userID: "",
                                            displayName: "TestName",
                                            email: "TestEmail",
                                            photoURL: "PhotoURL",
                                            token: "")
    
    static let categories: [CategoryModel] = [CategoryModel(id: "",
                                                            uid: "",
                                                            name: "Test",
                                                            color: "TestColor")]
    
    static let books: [Item] = [Item(id: "testID",
                                     bookID: "",
                                     favorite: true,
                                     ownerID: "",
                                     recommanding: true,
                                     volumeInfo: nil,
                                     saleInfo: nil,
                                     timestamp: 0,
                                     category: nil)]
    
    static let users: [UserModel] = [UserModel(id: "",
                                               userID: "",
                                               displayName: "TestUser",
                                               email: "TestEmail",
                                               photoURL: "testUrl",
                                               token: "TestToken")]
    
    static let category = CategoryModel(id: "", uid: "", name: "test", color: "")
    
    static let book: Item = Item(id: "testID",
                                 bookID: "",
                                 favorite: true,
                                 ownerID: "",
                                 recommanding: true,
                                 volumeInfo: nil,
                                 saleInfo: nil,
                                 timestamp: 0,
                                 category: nil)
    
    static let comment = CommentModel(id: "",
                                      uid: "",
                                      userID: "",
                                      comment: "",
                                      timestamp: 0)
    
    static let bookQuery = BookQuery(listType: HomeCollectionViewSections.favorites,
                                     orderedBy: .category,
                                     fieldValue: "",
                                     descending: true)
}
