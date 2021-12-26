//
//  NewBookAdapter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol NewBookAdapter {
    func getNewBookData(for book: Item, completion: @escaping(NewBookData) -> Void)
}
