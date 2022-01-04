//
//  NewBookDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/01/2022.
//

protocol NewBookDelegate: AnyObject {
    var newBook: Item? { get set }
    var bookDescription: String? { get set }
    var bookComment: String? { get set }
    var bookCategories : [String] { get set }
}
