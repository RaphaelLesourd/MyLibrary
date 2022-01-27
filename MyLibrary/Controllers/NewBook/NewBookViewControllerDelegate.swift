//
//  NewBookViewControllerDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/01/2022.
//

protocol NewBookViewControllerDelegate: AnyObject {
    func setDescription(with text: String)
    func setCategories(with list: [String])
    func setBookData(with item: ItemDTO?)
    func setLanguage(with code: String?)
    func setCurrency(with code: String?)
}
