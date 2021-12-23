//
//  LayoutComposer.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//
import UIKit

protocol DefaultLayoutComposer {
    func setCollectionViewLayout(gridItemSize: GridItemSize) -> UICollectionViewLayout
}
