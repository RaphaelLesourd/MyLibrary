//
//  CellPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol CellPresenter {
    func getBookData(for book: Item, completion: @escaping (BookCellData) -> Void)
}
