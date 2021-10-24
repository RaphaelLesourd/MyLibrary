//
//  BookImageView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import Foundation
import UIKit

class BookCoverImageButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        rounded(radius: 12, backgroundcolor: UIColor.label.withAlphaComponent(0.1))
        let image = UIImage(named: "cover")
        setImage(image, for: .normal)
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
