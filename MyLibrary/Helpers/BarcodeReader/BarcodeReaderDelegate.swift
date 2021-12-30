//
//  BarcodeProvider.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/12/2021.
//

protocol BarcodeReaderDelegate: AnyObject {
    func provideBarcode(with data: String?)
    func presentError(with error: BarcodeReaderError)
}
