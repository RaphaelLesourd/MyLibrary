//
//  NewBookControllerViewDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol NewBookViewDelegate: AnyObject {
    var isRecommending: Bool { get set }
    func saveBook()
    func clearData()
}
