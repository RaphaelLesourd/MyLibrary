//
//  NewBookDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/01/2022.
//

protocol NewBookViewControllerDelegate: AnyObject {
    var bookDescription: String? { get set }
    var bookComment: String? { get set }
    var bookCategories : [String] { get set }
    func displayBook(for item: Item?)
    func setLanguage(with code: String?)
    func setCurrency(with code: String?)
}
