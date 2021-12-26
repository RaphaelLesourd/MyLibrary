//
//  File.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

/// Protocol to pass barcode string value back to the requesting controller.
protocol BarcodeScannerDelegate: AnyObject {
    func processBarcode(with code: String)
}
