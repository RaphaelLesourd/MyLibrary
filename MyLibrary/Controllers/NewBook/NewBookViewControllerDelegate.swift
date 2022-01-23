//
//  NewBookDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/01/2022.
//

protocol NewBookViewControllerDelegate: AnyObject {
    func setDescription(with text: String)
    func setCategories(with list: [String])
    func displayBook(for item: Item?)
    func setLanguage(with code: String?)
    func setCurrency(with code: String?)
}
