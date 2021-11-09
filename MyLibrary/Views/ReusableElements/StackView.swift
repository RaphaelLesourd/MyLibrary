//
//  StackView.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/11/2021.
//

import Foundation
import UIKit

class StackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(axis:  NSLayoutConstraint.Axis,
                     distribution:  UIStackView.Distribution = .fill,
                     alignment: UIStackView.Alignment = .fill,
                     spacing: CGFloat,
                     resizingMask: Bool = false) {
        self.init(frame: .zero)
        self.axis          = axis
        self.distribution = distribution
        self.alignment    = alignment
        self.spacing      = spacing
        self.translatesAutoresizingMaskIntoConstraints = resizingMask
    }
}
