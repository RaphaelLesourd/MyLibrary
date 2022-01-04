//
//  NewBookPickerDataSource.swift
//  MyLibrary
//
//  Created by Birkyboy on 30/12/2021.
//

import UIKit

class NewBookPickerDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var newBookView: NewBookControllerView
    private let languageList = Locale.isoLanguageCodes
    private let currencyList = Locale.isoCurrencyCodes
    private let formatter: FormatterProtocol
    weak var delegate: NewBookPickerDelegate?
    
    init(newBookView: NewBookControllerView,
         formatter: FormatterProtocol,
         delegate: NewBookPickerDelegate) {
        self.newBookView = newBookView
        self.formatter = formatter
        self.delegate = delegate
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            pickerLabel?.textAlignment = .left
        }
        switch pickerView {
        case newBookView.languageCell.pickerView:
            let language = self.languageList[row]
            pickerLabel?.text = "  " + formatter.formatCodeToName(from: language, type: .language).capitalized
        case newBookView.currencyCell.pickerView:
            let currencyCode = self.currencyList[row]
            pickerLabel?.text = "  " + formatter.formatCodeToName(from: currencyCode, type: .currency).capitalized
        default:
            return UIView()
        }
        pickerLabel?.textColor = .label
        return pickerLabel ?? UILabel()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case newBookView.languageCell.pickerView:
            return languageList.count
        case newBookView.currencyCell.pickerView:
            return currencyList.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case newBookView.languageCell.pickerView:
            delegate?.chosenLanguage = languageList[row]
        case newBookView.currencyCell.pickerView:
            delegate?.chosenCurrency = currencyList[row]
        default:
            return
        }
    }
}
