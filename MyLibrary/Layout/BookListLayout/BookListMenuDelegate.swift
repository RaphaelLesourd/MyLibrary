//
//  BookListLayoutDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/12/2021.
//

protocol BookListMenuDelegate: AnyObject {
    func setLayoutFromMenu(for layout: BookGridSize)
    func orderList(by type: DocumentKey)
}
