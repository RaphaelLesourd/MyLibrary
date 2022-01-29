//
//  BookListLayoutComposer.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//
import UIKit

protocol BookListLayoutMaker {
    func makeCollectionViewLayout(gridItemSize: GridSize) -> UICollectionViewLayout
}
