//
//  BarcodeScannerDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 02/01/2022.
//

protocol BarcodeScannerDelegate: AnyObject {
    func processBarcode(with code: String)
}
