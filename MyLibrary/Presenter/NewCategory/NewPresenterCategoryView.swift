//
//  NewPresenterCategoryView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

import Foundation

protocol NewCategoryPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func updateCategory(at indexPath: IndexPath,  color: String, name: String)
    func updateBackgroundTint(with colorHex: String)
    func dismissViewController()
}
