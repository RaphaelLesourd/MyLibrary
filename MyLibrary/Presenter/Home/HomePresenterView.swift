//
//  HomePresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol HomePresenterView: AcitivityIndicatorProtocol, AnyObject {
    func applySnapshot(animatingDifferences: Bool)
    func presentBookLibraryController(for query: BookQuery?, title: String?)
    func presentBookCardController(with book: ItemDTO)
}
