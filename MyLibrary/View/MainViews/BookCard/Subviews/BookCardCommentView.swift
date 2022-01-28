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
        setTitleLabelConstraints()
        setArrowImageConstraints()
        setCommentButtonConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let goToCommentButton = UIButton()
    
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
                                       font: .sectionTitle)
    
    private let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.image = Images.commentViewBackground
        view.tintColor = UIColor.appTintColor.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let arrowImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.image = Images.ButtonIcon.rightArrow
        view.tintColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Setup
    private func setupView() {
        self.heightAnchor.constraint(equalToConstant: 120).isActive = true
        titleLabel.text = Text.SectionTitle.readersComment
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
    
    private func setTitleLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    private func setArrowImageConstraints() {
        addSubview(arrowImage)
        NSLayoutConstraint.activate([
            arrowImage.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            arrowImage.heightAnchor.constraint(equalToConstant: 25),
            arrowImage.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setCommentButtonConstraints() {
        addSubview(goToCommentButton)
        goToCommentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goToCommentButton.topAnchor.constraint(equalTo: topAnchor),
            goToCommentButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            goToCommentButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            goToCommentButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
