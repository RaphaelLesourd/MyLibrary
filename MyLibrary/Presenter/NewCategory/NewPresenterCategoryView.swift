//
//  NewPresenterCategoryView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

import Foundation

protocol NewCategoryPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func updateCategoryColor(at indexPath: IndexPath, and colorHex: String)
    func dismissViewController()
}
