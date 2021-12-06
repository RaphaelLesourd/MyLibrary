//
//  ImageLoader.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import UIKit
import Kingfisher

protocol ImageRetriverProtocol {
    func getImage(for url: String?, completion: @escaping (UIImage?) -> Void)
}

class ImageRetriver: ImageRetriverProtocol {
    
    func getImage(for url: String?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url, let imageURL = URL(string: url) else {
            completion(Images.emptyStateBookImage)
            return
        }
        KingfisherManager.shared.retrieveImage(with: imageURL,
                                               options: [.cacheOriginalImage, .keepCurrentImageWhileLoading],
                                               completionHandler: { response in
            switch response {
            case .success(let value):
                    completion(value.image)
            case .failure(_):
                completion(Images.emptyStateBookImage)
            }
        })
    }
}
