//
//  ListPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/01/2022.
//
import Foundation

protocol ListPresenterView: AnyObject {
    func setTitle(as title: String)
    func highlightCell(at indexPath: IndexPath)
    func setLanguage(with code: String)
    func setCurrency(with code: String)
    func applySnapshot(animatingDifferences: Bool)
    func reloadRow(for item: ListRepresentable)
}

class ListPresenter {
    
    // MARK: - Properties
    weak var view: ListPresenterView?
    var data: [ListRepresentable] = []
    private(set) var originalData: [ListRepresentable] = []
    var receivedData: String?
    
    private let listDataType: ListDataType
    private let formatter: Formatter
    var favorites: [String] = []
    
    // MARK: - Initializer
    init(listDataType: ListDataType,
         formatter: Formatter) {
        self.listDataType = listDataType
        self.formatter = formatter
    }
    
    // MARK: - Public functions
    func getData() {
        let list = createList(for: listDataType)
        originalData = list.sorted(by: { $0.title.lowercased() < $1.title.lowercased() })
        data = originalData
        view?.applySnapshot(animatingDifferences: true)
    }
    
    func getControllerTitle() {
        view?.setTitle(as: listDataType.title)
    }
   
    // MARK: Hightlight book data
    func highlightCell() {
        if let index = data.firstIndex(where: { $0.subtitle.lowercased() == receivedData?.lowercased() }) {
            let indexPath = IndexPath(row: index, section: 0)
            view?.highlightCell(at: indexPath)
        }
    }
    
    // MARK: Send selected data
    func getSelectedData(from data: ListRepresentable?) {
        guard let data = data else { return }
        switch listDataType {
        case .languages:
            view?.setLanguage(with: data.subtitle)
        case .currency:
            view?.setCurrency(with: data.subtitle)
        }
    }
    
    // MARK: Filtering
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
    
    // MARK: Favorite
    func getFavorites() {
        if let data = UserDefaults.standard.object(forKey: "favorite" + listDataType.rawValue) as? [String] {
            favorites = data
            view?.applySnapshot(animatingDifferences: true)
        }
    }
    
    func addToFavorite(with data: ListRepresentable) {
        favorites.append(data.subtitle)
        saveFavorites()
        updateData(favorite: true, for: data.subtitle)
        view?.reloadRow(for: data)
        print(data.subtitle)
        print(favorites)
    }
    
    func removeFavorite(with data: ListRepresentable) {
        if let index = favorites.firstIndex(where: { $0.lowercased() == data.subtitle.lowercased() }) {
            favorites.remove(at: index)
            saveFavorites()
            updateData(favorite: false, for: data.subtitle)
            view?.reloadRow(for: data)
            print(data.subtitle)
            print(favorites)
        }
    }
    
    // MARK: - Private functions
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
    
    private func saveFavorites() {
        UserDefaults.standard.set(favorites, forKey: "favorite" + listDataType.rawValue)
    }
    
    private func updateData(favorite: Bool, for code: String) {
        if let index = data.firstIndex(where: { $0.subtitle.lowercased() == code.lowercased() }) {
            data[index].favorite = favorite
        }
        if let index = originalData.firstIndex(where: { $0.subtitle.lowercased() == code.lowercased() }) {
            originalData[index].favorite = favorite
        }
    }
}
