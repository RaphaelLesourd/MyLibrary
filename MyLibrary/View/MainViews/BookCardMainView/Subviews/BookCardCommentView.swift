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
        setupView()
        setBackgroundImageConstraints()
        setAnimationViewConstraints()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let goToCommentButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "arrow.right.circle", withConfiguration: configuration)
        button.contentHorizontalAlignment = .right
        button.setImage(image, for: .normal)
        return button
    }()
    
    let animationView: AnimationView = {
        let animationView = AnimationView()
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animation = Animation.named("CommentsLottieAnimation")
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.alpha = 0.8
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    private let titleLabel = TextLabel(color: .label,
                                       maxLines: 2,
                                       alignment: .right,
                                       fontSize: 16,
                                       weight: .medium)
    
    private let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.image = UIImage(named: "commentBubbleBG")
        view.tintColor = UIColor.appTintColor.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView = StackView(axis: .vertical,
                                      spacing: 0)
    
    // MARK: - Setup
    private func setupView() {
        titleLabel.text = Text.SectionTitle.readersComment
        stackView.addArrangedSubview(goToCommentButton)
        stackView.addArrangedSubview(titleLabel)
    }
}
// MARK: - Constraints
extension BookCardCommentView {
    private func setBackgroundImageConstraints() {
        addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setAnimationViewConstraints() {
        addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: topAnchor, constant: -20),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20),
            animationView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
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
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
