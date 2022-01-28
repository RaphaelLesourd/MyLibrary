//
//  LibraryPresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol LibraryPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func applySnapshot(animatingDifferences: Bool)
    func updateSectionTitle(with title: String?)
}
