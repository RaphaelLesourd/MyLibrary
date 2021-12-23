//
//  ImageLoader.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import UIKit
import Kingfisher

class KingFisherImageRetriever: ImageRetriever {
    
    func getImage(for url: String?, completion: @escaping (UIImage) -> Void) {
        guard let url = url, let imageURL = URL(string: url) else {
            completion(Images.emptyStateBookImage)
            return
        }
        let options: KingfisherOptionsInfo = [.cacheOriginalImage, .keepCurrentImageWhileLoading]
        KingfisherManager.shared.retrieveImage(with: imageURL, options: options, completionHandler: { response in
            switch response {
            case .success(let value):
                    completion(value.image)
            case .failure(_):
                completion(Images.emptyStateBookImage)
            }
        })
    }
}
