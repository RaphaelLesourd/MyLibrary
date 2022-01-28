//
//  OnboardingMainView.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/01/2022.
//

import UIKit

class OnboardingMainView: UIView {
    
    weak var delegate: OnboardingMainViewDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        addButtonsAction()
        setBackGroundImageConstraints()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.register(cell: OnboardingCollectionViewCell.self)
        collection.alwaysBounceHorizontal = true
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.7)
        control.currentPageIndicatorTintColor = .systemOrange
        return control
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.ButtonTitle.skip, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = .subtitle
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.welcomeScreen
        imageView.alpha = 0.3
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nextButton = Button(title: Text.ButtonTitle.next,
                                    icon: Images.ButtonIcon.rightArrow,
                                    imagePlacement: .trailing,
                                    tintColor: .systemOrange,
                                    backgroundColor: .systemOrange)
    
    private let stackView = StackView(axis: .vertical,
                                      alignment: .center,
                                      spacing: 20)
    
    // MARK: - Configure
    func setOnboardingSeen(when finished: Bool) {
        let title = finished ? Text.ButtonTitle.done : Text.ButtonTitle.next
        nextButton.setTitle(title, for: .normal)
    }
    
    private func setupView() {
        stackView.addArrangedSubview(skipButton)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(pageControl)
        stackView.addArrangedSubview(nextButton)
    }
    
    private func addButtonsAction() {
        skipButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.skip()
        }), for: .touchUpInside)
        
        nextButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.next()
        }), for: .touchUpInside)
    }
}
// MARK: - Constraints
extension OnboardingMainView {
    private func setBackGroundImageConstraints() {
        addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setConstraints() {
        addSubview(stackView)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            nextButton.widthAnchor.constraint(equalToConstant: 150),
            collectionView.widthAnchor.constraint(equalTo: widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
