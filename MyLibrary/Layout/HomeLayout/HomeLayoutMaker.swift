//
//  HomeLayoutComposer.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

import UIKit

protocol HomeLayoutMaker {
    func makeCollectionViewLayout(dataSource: UICollectionViewDiffableDataSource<HomeCollectionViewSections,
                                 AnyHashable>) -> UICollectionViewLayout
}
