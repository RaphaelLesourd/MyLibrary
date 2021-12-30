//
//  BookCardDataPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol BookCardPresenter {
    func configure(_ view: BookCardMainView, with book: Item)
    func setCategoriesLabel(_ view: BookCardMainView, for categoryIds: [String], bookOwnerID: String)
}
