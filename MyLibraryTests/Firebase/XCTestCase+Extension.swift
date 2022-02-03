//
//  XCTestCase+Extension.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 23/11/2021.
//

import XCTest
import Firebase
@testable import MyLibrary

extension XCTestCase {
    
    func clearFirestore() {
        let semaphore = DispatchSemaphore(value: 0)
        let projectId = FirebaseApp.app()!.options.projectID!
        let url = URL(string: "http://localhost:8080/emulator/v1/projects/\(projectId)/databases/(default)/documents")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { _,_,_ in
            print("Firestore cleared")
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func createUserData() -> UserModelDTO {
        let credentials = AccountCredentials(userName: "testuser",
                                             email: "testuser@test.com",
                                             password: "Test21@",
                                             confirmPassword: "Test21@")
        return UserModelDTO(userID: "user1",
                         displayName: credentials.userName ?? "test",
                         email: credentials.email,
                         photoURL: "",
                         token: "")
    }
    
    func createBookDocumentData() -> ItemDTO {
        let volumeInfo = VolumeInfo(title: "title",
                                    authors: ["author"],
                                    publisher: "publisher",
                                    publishedDate: "1900",
                                    volumeInfoDescription:"decription",
                                    industryIdentifiers: [IndustryIdentifier(identifier:"1234567890")],
                                    pageCount: 0,
                                    ratingsCount: 0,
                                    imageLinks: ImageLinks(thumbnail: "thumbnailURL"),
                                    language: "language")
        let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: 0.0, currencyCode: "CUR"))
        return ItemDTO(id: "1111111",
                    bookID: "11111111",
                    favorite: true,
                    ownerID: "user1",
                    recommanding: true,
                    volumeInfo: volumeInfo,
                    saleInfo: saleInfo,
                    timestamp: 0,
                    category: [])
    }
}
