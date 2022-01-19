//
//  CommentBookCellConfiguration.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import UIKit

class CommentBookCellConfiguration {
    // MARK: - Properties
    private var imageRetriever: ImageRetriever
    private var commentService: CommentServiceProtocol
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever,
         commentService: CommentServiceProtocol) {
        self.imageRetriever = imageRetriever
        self.commentService = commentService
    }
    
    private func getImageCover(for book: Item, completion: @escaping(UIImage) -> Void) {
        imageRetriever.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { image in
            completion(image)
        }
    }
    private func getBookOwnerName(book: Item, completion: @escaping(String?) -> Void) {
        guard let ownerID = book.ownerID else { return }
        self.commentService.getUserDetail(for: ownerID) { result in
            if case .success(let owner) = result {
                let name = owner.map({ $0.displayName })
                completion(name)
            }
        }
    }
}
// MARK: Cell presenter
extension CommentBookCellConfiguration: CommentBookCellViewConfigure {
    
    func setBookData(for book: Item, completion: @escaping (CommentBookCellData) -> Void) {
        let title = book.volumeInfo?.title?.capitalized ?? ""
        let authors = book.volumeInfo?.authors?.joined(separator: ", ") ?? ""
       
        getBookOwnerName(book: book) { [weak self] name in
            self?.getImageCover(for: book) { image in
                let data = CommentBookCellData(title: title,
                                               authors: authors,
                                               image: image,
                                               ownerName: name)
                completion(data)
            }
        }
        
    }
}
