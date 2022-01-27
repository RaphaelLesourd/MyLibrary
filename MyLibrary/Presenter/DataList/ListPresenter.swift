//
//  ListPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/01/2022.
//
import Foundation

class ListPresenter {
    
    // MARK: - Properties
    weak var view: ListPresenterView?
    var data: [ListRepresentable] = []
    var selection: String?
    var favorites: [String] = []
    
    private var originalData: [ListRepresentable] = []
    private let listDataType: ListDataType
    private let formatter: Formatter
    
    // MARK: - Initializer
    init(listDataType: ListDataType,
         formatter: Formatter) {
        self.listDataType = listDataType
        self.formatter = formatter
        getFavorites()
    }
    
    /// Create an array of ListRepresentable for list type.
    /// - Parameters:
    /// - listType: ListDataType Enum case
    /// - returns: Array of ListRepresentable objects to be displayed by the cell
    private func createList(for listType: ListDataType) -> [ListRepresentable] {
        let data = listDataType.code.compactMap { documents -> ListRepresentable in
            let title = formatter.formatCodeToName(from: documents, type: listType)
            let isFavorite = favorites.contains(documents)
            return ListRepresentable(title: title, subtitle: documents, favorite: isFavorite)
        }.filter({
            !$0.title.isEmpty
        })
        return data
    }
    
    /// Fetch favorites  from UserDefault
    private func getFavorites() {
        if let data = UserDefaults.standard.object(forKey: "favorite" + listDataType.rawValue) as? [String] {
            favorites = data
        }
    }
    
    /// Save favortites to UserDefault
    private func saveFavorites() {
        UserDefaults.standard.set(favorites, forKey: "favorite" + listDataType.rawValue)
    }
    
    /// Update favorite property of the data and originalData arrays
    /// - Parameters:
    ///  - favorite: Bool value
    ///  - code: String value user to find the object to update in the array/
    private func updateData(favorite: Bool, for code: String) {
        if let index = data.firstIndex(where: { $0.subtitle.lowercased() == code.lowercased() }) {
            data[index].favorite = favorite
        }
        if let index = originalData.firstIndex(where: { $0.subtitle.lowercased() == code.lowercased() }) {
            originalData[index].favorite = favorite
        }
    }
}
extension ListPresenter: ListPresenting {
   
    /// Get the data for the chosen list type
    func getData() {
        let list = createList(for: listDataType)
        originalData = list.sorted(by: { $0.title.lowercased() < $1.title.lowercased() })
        data = originalData
        view?.applySnapshot(animatingDifferences: true)
    }
    
    /// Get the controller title for thechosen  list type
    func getControllerTitle() {
        view?.setTitle(as: listDataType.title)
    }
   
    /// Highlight the cell for the selected data received by the viewController
    func highlightCell() {
        if let index = data.firstIndex(where: { $0.subtitle.lowercased() == selection?.lowercased() }) {
            view?.highlightCell(for: data[index])
        }
    }
    
    /// Get the selected cell data and pass it back to the relevant method according the list type
    func getSelectedData(from data: ListRepresentable?) {
        guard let data = data else { return }
        selection = nil
        switch listDataType {
        case .languages:
            view?.setLanguage(with: data.subtitle)
        case .currency:
            view?.setCurrency(with: data.subtitle)
        }
    }
    
    /// Filters the orginalData type
    /// - Parameters:
    /// - text: String of the value to find
    func filterList(with text: String) {
        if text.isEmpty {
            data = originalData
        } else {
            data = originalData.filter({
                let title = $0.title.lowercased()
                let subtitle = $0.subtitle.lowercased()
                return title.contains(text.lowercased()) || subtitle.contains(text.lowercased())
            })
        }
        view?.applySnapshot(animatingDifferences: true)
    }
    
    /// Add a ListRepresentable object to the Favorite array
    /// - Parameters:
    /// - data: ListRepresentable object
    func addToFavorite(with data: ListRepresentable) {
        favorites.append(data.subtitle)
        saveFavorites()
        updateData(favorite: true, for: data.subtitle)
        view?.reloadRow(for: data)
    }
    
    /// Remove a ListRepresentable object from the Favorite array
    /// - Parameters:
    /// - data: ListRepresentable object
    func removeFavorite(with data: ListRepresentable) {
        if let index = favorites.firstIndex(where: { $0.lowercased() == data.subtitle.lowercased() }) {
            favorites.remove(at: index)
            saveFavorites()
            updateData(favorite: false, for: data.subtitle)
            view?.reloadRow(for: data)
        }
    }
}
