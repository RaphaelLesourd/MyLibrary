//
//  HomePresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol HomePresenting {
    var view: HomePresenterView? { get set }
    var categories: [CategoryModel] { get set }
    var latestBooks: [Item] { get set }
    var favoriteBooks: [Item] { get set }
    var recommandedBooks: [Item] { get set }
    var followedUser: [UserModel] { get set }
    func getCategories()
    func getLatestBooks()
    func getFavoriteBooks()
    func getRecommendations()
    func getUsers()
    func makeBookCellRepresentable(for book: Item) -> BookCellRepresentable
    func setUserData(with user: UserModel) -> UserCellRepresentable
}
