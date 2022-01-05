//
//  RecommendationServiceProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol RecommendationServiceProtocol {
    func addToRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void)
    func removeFromRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void)
    func retrieveRecommendingUsers(completion: @escaping (Result<[UserModel], FirebaseError>) -> Void)
}
