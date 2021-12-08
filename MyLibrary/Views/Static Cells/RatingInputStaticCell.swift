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
        backgroundColor = .tertiarySystemBackground
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(ratingSegmentedControl)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String) {
        self.init()
        titleLabel.text = placeholder
    }
    // MARK: - Subviews
    let titleLabel = TextLabel(color: .secondaryLabel, maxLines: 2, alignment: .left, fontSize: 12, weight: .regular)
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
    private let stackView = StackView(axis: .horizontal, distribution: .fill, spacing: 0)
}
// MARK: - Constraints
extension RatingInputStaticCell {
    private func setConstraints() {
        contentView.addSubview(stackView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 70),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
