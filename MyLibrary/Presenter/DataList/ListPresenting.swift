//
//  ListPresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol ListPresenting {
    var view: ListPresenterView? { get set }
    var data: [ListRepresentable] { get set }
    var selection: String? { get set }
    var favorites: [String] { get set }
    func getData()
    func getControllerTitle()
    func highlightCell()
    func filterList(with text: String)
    func addToFavorite(with data: ListRepresentable)
    func removeFavorite(with data: ListRepresentable)
    func getSelectedData(from data: ListRepresentable?)
}
