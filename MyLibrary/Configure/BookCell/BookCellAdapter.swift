//
//  BookCellConfigure.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol BookCellAdapter {
    func setBookData(for book: Item, completion: @escaping (BookCellData) -> Void)
}
