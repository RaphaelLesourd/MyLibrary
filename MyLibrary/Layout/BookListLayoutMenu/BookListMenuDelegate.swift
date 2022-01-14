//
//  BookListLayoutDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/12/2021.
//

protocol BookListMenuDelegate: AnyObject {
    func setLayoutFromMenu(for layout: GridSize)
    func orderList(by type:QueryType)
}
