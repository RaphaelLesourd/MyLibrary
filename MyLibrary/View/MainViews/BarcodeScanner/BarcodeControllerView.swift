//
//  BarcodeControllerView.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/12/2021.
//

import UIKit
import Lottie

protocol BarcodeControllerViewDelegate: AnyObject {
    func toggleFlashlight()
}

class BarcodeControllerView: UIView {
    
    weak var delegate: BarcodeControllerViewDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        addButtonAction()
        setStackViewConstraints()
        setAnimationViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews    
    let videoPreviewContainerView: UIView = {
        let view = UIView()
        view.roundView(radius: 12, backgroundColor: .systemBackground)
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
    private let flashLightButton = UIButton()
    
    private let titleLabel = TextLabel(color: .label,
                                       maxLines: 2,
                                       alignment: .left,
                                       font: .controllerTitle)
    private let infoLabel = TextLabel(color: .label,
                                      maxLines: 1,
                                      alignment: .left,
                                      font: .footerLabel)
    private let titleStackView = StackView(axis: .vertical,
                                           spacing: 5)
    private let headerStackView = StackView(axis: .horizontal,
                                            distribution: .fillProportionally,
                                            spacing: 10)
    private let stackView = StackView(axis: .vertical,
                                      distribution: .fillProportionally,
                                      spacing: 20)
    
    // MARK: - Configure
    func toggleButton(onState: Bool) {
        let configuration = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular, scale: .medium)
        let onImage = Images.ButtonIcon.lightBulbOn?.withConfiguration(configuration)
        let offImage = Images.ButtonIcon.lightBulbOff?.withConfiguration(configuration)
        let buttonImage = onState ? onImage : offImage
        flashLightButton.setImage(buttonImage, for: .normal)
        flashLightButton.tintColor = onState ? .systemOrange : .label
    }
    
    private func setupView() {
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(infoLabel)
        
        headerStackView.addArrangedSubview(titleStackView)
        headerStackView.addArrangedSubview(flashLightButton)
        
        stackView.addArrangedSubview(headerStackView)
        stackView.addArrangedSubview(videoPreviewContainerView)
        toggleButton(onState: false)
        titleLabel.text = Text.ControllerTitle.barcodeController
        infoLabel.text = Text.ControllerTitle.barcodeControllerSubitle
    }
    
    private func addButtonAction() {
        flashLightButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.toggleFlashlight()
        }), for: .touchUpInside)
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
