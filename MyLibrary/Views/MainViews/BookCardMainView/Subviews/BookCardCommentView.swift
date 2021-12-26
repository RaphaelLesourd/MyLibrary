//
//  BookCardCommentView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/11/2021.
//

import UIKit
import Lottie

class BookCardCommentView: UIView {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        rounded(radius: 10, backgroundColor: UIColor.label.withAlphaComponent(0.05))
        titleLabel.text = Text.SectionTitle.readersComment
        stackView.addArrangedSubview(goToCommentButton)
        stackView.addArrangedSubview(titleLabel)
        
        setAnimationViewConstraints()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews
    let goToCommentButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "arrow.right.circle", withConfiguration: configuration)
        button.contentHorizontalAlignment = .right
        button.setImage(image, for: .normal)
        return button
    }()
    let animationView: AnimationView = {
        let animationView = AnimationView()
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.animation = Animation.named("CommentsLottieAnimation")
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.alpha = 0.8
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    private let titleLabel = TextLabel(color: .label,
                                       maxLines: 2,
                                       alignment: .right,
                                       fontSize: 14,
                                       weight: .medium)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 0)
}
// MARK: - Constraints
extension BookCardCommentView {
    private func setAnimationViewConstraints() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor),
            animationView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            animationView.heightAnchor.constraint(equalToConstant: 70),
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -10)
        ])
    }
    
    private func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
           stackView.topAnchor.constraint(equalTo: topAnchor),
           stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
           stackView.leadingAnchor.constraint(equalTo: animationView.trailingAnchor, constant: -40),
           stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
