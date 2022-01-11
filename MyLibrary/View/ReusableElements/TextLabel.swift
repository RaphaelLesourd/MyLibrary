//
//  Label.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class TextLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor = .label,
                     maxLines: Int = 1,
                     alignment: NSTextAlignment = .left,
                     font: UIFont) {
        self.init(frame: .zero)
        commonInit(color: color, maxLines: maxLines, alignment: alignment, font: font)
    }
    
    private func commonInit(color: UIColor = .label,
                            maxLines: Int = 1,
                            alignment: NSTextAlignment = .left,
                            font: UIFont) {
        self.textColor = color
        self.numberOfLines = maxLines
        self.textAlignment = alignment
        self.text = "--"
        self.font = font
        self.adjustsFontSizeToFitWidth = true
    }
}
