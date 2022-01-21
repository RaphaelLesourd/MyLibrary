//
//  CommentBookCellConfigure.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

protocol CommentBookCellViewConfigure {
    func setBookData(for book: Item, completion: @escaping (CommentBookCellData) -> Void)
}
