//
//  RatingView.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/11/2021.
//

import UIKit

class RatingView: UIView {
    
    // MARK: - Properties
    var rating: Int = 0 {
      didSet {
        for index in 0..<5 {
            imageViews[index].tintColor = index < rating ? .ratingColor : UIColor.ratingColor.withAlphaComponent(0.2)
        }
      }
    }
    private let imageViews: [UIImageView]
   
    // MARK: - Initializer
    init() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .medium)
        
        imageViews = (0..<5).map { _ in
            UIImageView(image: UIImage(systemName: "star.fill", withConfiguration: imageConfig))
        }
        super.init(frame: .zero)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for view in imageViews {
            stackView.addArrangedSubview(view)
        }
        addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
