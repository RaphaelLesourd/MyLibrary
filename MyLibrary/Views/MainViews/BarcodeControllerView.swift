//
//  BarcodeControllerView.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/12/2021.
//

import UIKit
import Lottie

class BarcodeControllerView: UIView {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(videoPreviewContainerView)
        stackView.setCustomSpacing(20, after: infoLabel)
        
        setStackViewConstraints()
        setAnimationViewConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews    
    let videoPreviewContainerView: UIView = {
        let view = UIView()
        view.rounded(radius: 12, backgroundColor: .systemBackground)
        return view
    }()
    let animationView: AnimationView = {
        let animationView = AnimationView()
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animation = Animation.named("scanner")
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    private let titleLabel = TextLabel(color: .label, maxLines: 2, alignment: .left, fontSize: 25, weight: .bold)
    private let infoLabel = TextLabel(color: .label, maxLines: 1, alignment: .left, fontSize: 14, weight: .light)
    private let stackView = StackView(axis: .vertical, distribution: .fillProportionally, spacing: 5)
    
    // MARK: - Configure
    private func configureView() {
        titleLabel.text = Text.ControllerTitle.barcodeController
        infoLabel.text = Text.ControllerTitle.barcodeControllerSubitle
    }
}
// MARK: - Constraints
extension BarcodeControllerView {
    private func setStackViewConstraints() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setAnimationViewConstraints() {
        videoPreviewContainerView.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: videoPreviewContainerView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: videoPreviewContainerView.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: videoPreviewContainerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: videoPreviewContainerView.trailingAnchor)
        ])
    }
}
