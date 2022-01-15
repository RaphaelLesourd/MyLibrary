//
//  NewBokPickerDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/01/2022.
//

protocol NewBookPickerDelegate: AnyObject {
    var chosenLanguage: String? { get set }
    var chosenCurrency: String? { get set }
}
