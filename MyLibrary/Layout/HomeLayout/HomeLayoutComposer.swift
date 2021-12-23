//
//  HomeLayoutComposer.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

import UIKit

protocol HomeLayoutComposer {
    func setCollectionViewLayout(dataSource: UICollectionViewDiffableDataSource<HomeCollectionViewSections,
                                 AnyHashable>) -> UICollectionViewLayout
}
