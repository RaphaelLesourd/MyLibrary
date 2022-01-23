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
    
    private static let volumeInfo = VolumeInfo(title: "title",
                                authors: [""],
                                publisher: "",
                                publishedDate: "",
                                volumeInfoDescription: "",
                                industryIdentifiers: [IndustryIdentifier(identifier: "")],
                                pageCount: 0,
                                ratingsCount: 0,
                                imageLinks: ImageLinks(thumbnail: ""),
                                language: "")
    private static let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: 0.0,
                                                           currencyCode: ""))
    static let books: [Item] = [Item(id: "testID",
                                     bookID: "",
                                     favorite: true,
                                     ownerID: "",
                                     recommanding: true,
                                     volumeInfo: PresenterFakeData.volumeInfo,
                                     saleInfo: PresenterFakeData.saleInfo,
                                     timestamp: 0,
                                     category: [])]
    
    static let users: [UserModel] = [UserModel(id: "1",
                                               userID: "1",
                                               displayName: "TestUser",
                                               email: "TestEmail",
                                               photoURL: "testUrl",
                                               token: "TestToken")]
    
    static let category = CategoryModel(id: "1", uid: "1", name: "test", color: "AAAAA")
    
    static let book: Item = Item(id: "testID",
                                 bookID: "1",
                                 favorite: true,
                                 ownerID: "1",
                                 recommanding: true,
                                 volumeInfo: PresenterFakeData.volumeInfo,
                                 saleInfo: PresenterFakeData.saleInfo,
                                 timestamp: 0,
                                 category: [])
    
    static let comment = CommentModel(id: "1",
                                      uid: "1",
                                      userID: "1",
                                      message: "test",
                                      timestamp: 10000)
    
    static let bookQuery = BookQuery(listType: HomeCollectionViewSections.favorites,
                                     orderedBy: .category,
                                     fieldValue: "",
                                     descending: true)
}
