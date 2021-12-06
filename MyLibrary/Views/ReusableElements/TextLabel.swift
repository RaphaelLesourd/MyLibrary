//
//  Label.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import Foundation
import UIKit

class TextLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    convenience init(color: UIColor = .label,
                     maxLines: Int = 1,
                     alignment: NSTextAlignment = .left,
                     fontSize: CGFloat = 14,
                     weight: UIFont.Weight = .regular) {
        self.init(frame: .zero)
        commonInit(color: color, maxLines: maxLines, alignment: alignment, fontSize: fontSize, weight: weight)
    }
    
    private func commonInit(color: UIColor = .label,
                            maxLines: Int = 1,
                            alignment: NSTextAlignment = .left,
                            fontSize: CGFloat = 14,
                            weight: UIFont.Weight = .regular) {
        self.textColor     = color
        self.numberOfLines = maxLines
        self.textAlignment = alignment
        self.font          = UIFont.systemFont(ofSize: fontSize, weight: weight)
        self.text          = "--"
    }
}
