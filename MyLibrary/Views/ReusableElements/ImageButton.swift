//
//  BookImageView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import Foundation
import UIKit

class ImageButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commontInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(radius: CGFloat, backgrounColor: UIColor) {
        self.init(frame: .zero)
        rounded(radius: radius, backgroundColor: backgrounColor)
    }
    
    func commontInit(radius: CGFloat = 7, backgrounColor: UIColor = UIColor.label.withAlphaComponent(0.1)) {
        contentMode = .scaleAspectFill
        rounded(radius: radius, backgroundColor: backgrounColor)
        let image = UIImage(named: "cover")
        setImage(image, for: .normal)
        isUserInteractionEnabled = false
    }
}
