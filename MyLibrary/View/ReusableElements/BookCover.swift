//
//  BookImageView.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit

class BookCover: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFill
        self.image = Images.emptyStateBookImage
        self.isUserInteractionEnabled = true
        self.roundView(radius: 5, backgroundColor: .clear)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
