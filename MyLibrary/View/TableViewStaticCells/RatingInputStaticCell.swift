//
//  RatingInputStaticCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 14/11/2021.
//

import UIKit

class RatingInputStaticCell: UITableViewCell {
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .tertiarySystemBackground
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews
    let ratingSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["✗","1 ★","2 ★","3 ★","4 ★","5 ★"])
        control.isSpringLoaded = true
        control.tintColor = .clear
        control.selectedSegmentIndex = 0
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = .appTintColor
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        control.setTitleTextAttributes(titleTextAttributes, for:.normal)
        
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        control.setTitleTextAttributes(titleTextAttributes1, for: .selected)
      
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
}
// MARK: - Constraints
extension RatingInputStaticCell {
    private func setConstraints() {
        contentView.addSubview(ratingSegmentedControl)
        NSLayoutConstraint.activate([
            ratingSegmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            ratingSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
    }
}
