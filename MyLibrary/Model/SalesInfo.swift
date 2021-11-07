//
//  SalesInfos.swift
//  MyLibrary
//
//  Created by Birkyboy on 06/11/2021.
//

import Foundation

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let retailPrice: SaleInfoListPrice?
}

// MARK: - SaleInfoListPrice
struct SaleInfoListPrice: Codable {
    let amount: Double?
    let currencyCode: String?
}
