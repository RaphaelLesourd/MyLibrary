//
//  File.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol NewBookDelegate: AnyObject {
    var newBook: Item? { get set }
    var bookDescription: String? { get set }
    var bookComment: String? { get set }
    var bookCategories : [String] { get set }
}
