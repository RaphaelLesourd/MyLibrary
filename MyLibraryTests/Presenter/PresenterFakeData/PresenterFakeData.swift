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
    
    static let categories: [CategoryModel] = [CategoryModel(id: "1",
                                                            uid: "1",
                                                            name: "First",
                                                            color: "TestColor"),
                                              CategoryModel(id: "2",
                                                            uid: "2",
                                                            name: "Second",
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
    
    static let category = CategoryModel(id: "1", uid: "1", name: "test", color: "AAAAA")
    
    static let book: Item = Item(id: "testID",
                                 bookID: "",
                                 favorite: true,
                                 ownerID: "",
                                 recommanding: true,
                                 volumeInfo: nil,
                                 saleInfo: nil,
                                 timestamp: 0,
                                 category: [])
    
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
