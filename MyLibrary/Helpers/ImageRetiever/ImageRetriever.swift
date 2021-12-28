//
//  ImageRetriever.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

import UIKit

protocol ImageRetriever {
    func getImage(for url: String?, completion: @escaping (UIImage) -> Void)
}
