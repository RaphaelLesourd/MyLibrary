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
    func highlightCellForCode(at indexPath: IndexPath)
    func reloadTableView()
    func setLanguage(with code: String)
    func setCurrency(with code: String)
}

class ListPresenter {
    
    // MARK: - Properties
    weak var view: ListPresenterView?
    
    var data: [ListRepresentable] = []
    var orginalData: [ListRepresentable] = []
    private let listDataType: ListDataType
    private let formatter: Formatter
    
    // MARK: - Initializer
    init(listDataType: ListDataType,
         formatter: Formatter) {
        self.listDataType = listDataType
        self.formatter = formatter
    }
   
    // MARK: - Public functions
    func getControllerTitle() {
        view?.setTitle(as: listDataType.title)
    }
    
    func getSectionTitle() {
        view?.setSectionTitle(as: listDataType.sectionTitle)
    }
    
    func getData() {
        let data = createReferenceData(for: listDataType)
        orginalData = data.sorted(by: { $0.title.lowercased() < $1.title.lowercased() })
        self.data = orginalData
        view?.reloadTableView()
    }
    
    func filterData(with text: String) {
        if text.isEmpty {
            data = orginalData
        } else {
            data = orginalData.filter({
                let title = $0.title.lowercased()
                let subtitle = $0.subtitle.lowercased()
                return title.contains(text.lowercased()) || subtitle.contains(text.lowercased())
            })
        }
        view?.reloadTableView()
    }
    
    func highlightCell(for code: String?) {
        if let index = data.firstIndex(where: { $0.title.lowercased() == code?.lowercased() }) {
            let indexPath = IndexPath(row: index, section: 0)
            view?.highlightCellForCode(at: indexPath)
        }
    }
    
    func getCurrentData(at index: Int) {
        switch listDataType {
        case .languages:
            view?.setLanguage(with: data[index].subtitle)
        case .currency:
            view?.setCurrency(with: data[index].subtitle)
        }
    }
    
    // MARK: - Private functions
    private func createReferenceData(for listType: ListDataType) -> [ListRepresentable] {
        let data = listDataType.code.compactMap { documents -> ListRepresentable in
            let title = formatter.formatCodeToName(from: documents, type: listType)
            return ListRepresentable(title: title,
                                     subtitle: documents)
        }.filter({
            !$0.title.isEmpty
        })
        return data
    }
}
