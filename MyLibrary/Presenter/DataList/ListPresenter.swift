//
//  ListPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/01/2022.
//
import Foundation

protocol ListPresenterView: AnyObject {
    func setTitle(as title: String)
    func setSectionTitle(as title: String)
    func highlightCell(at indexPath: IndexPath)
    func reloadTableView()
    func setLanguage(with code: String)
    func setCurrency(with code: String)
    func reloadTableViewRow(at indexPath: IndexPath)
}

class ListPresenter {
    
    // MARK: - Properties
    weak var view: ListPresenterView?
    var data: [ListRepresentable] = []
    var originalData: [ListRepresentable] = []
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
        view?.reloadTableView()
    }
    
    func getControllerTitle() {
        view?.setTitle(as: listDataType.title)
    }
    
    func getSectionTitle() {
        view?.setSectionTitle(as: listDataType.sectionTitle)
    }

    // MARK: Hightlight book data
    func highlightCell() {
        if let index = data.firstIndex(where: { $0.subtitle.lowercased() == receivedData?.lowercased() }) {
            let indexPath = IndexPath(row: index, section: 0)
            view?.highlightCell(at: indexPath)
        }
    }
    
    // MARK: Send selected data
    func getSelectedData(at index: Int) {
        switch listDataType {
        case .languages:
            view?.setLanguage(with: data[index].subtitle)
        case .currency:
            view?.setCurrency(with: data[index].subtitle)
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
        view?.reloadTableView()
    }
    
    // MARK: Favorite
    func getFavoriteList() {
        if let data = UserDefaults.standard.object(forKey: "favorite" + listDataType.rawValue) as? [String] {
            favorites = data
        }
        view?.reloadTableView()
    }
    
    func addToFavorite(for index: Int) {
        let dataToAdd = data[index].subtitle
        favorites.append(dataToAdd)
        updateData(favorite: true, for: dataToAdd)
        saveFavorites()
        reloadTableViewRow(at: index)
    }
    
    func removeFavorite(at index: Int) {
        let dataToRemove = data[index].subtitle
        if let index = favorites.firstIndex(where: { $0.lowercased() == dataToRemove.lowercased() }) {
            favorites.remove(at: index)
            updateData(favorite: false, for: dataToRemove)
            saveFavorites()
        }
        reloadTableViewRow(at: index)
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
    
    private func reloadTableViewRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        view?.reloadTableViewRow(at: indexPath)
    }
}
