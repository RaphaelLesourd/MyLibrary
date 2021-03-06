//
//  BookCardMainView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import Lottie

class BookCardMainView: UIView {
    
    weak var delegate: BookCardMainViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addButtonActions()
        setImageAnimation()
        setScrollViewConstraints()
        setBackgroundImageConstraint()
        setBookCoverConstraints()
        setupMainstackView()
        setFavoriteButtonConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        backgroundImage.addFadeGradient()
    }

    // MARK: - Subviews
    let activityIndicator = UIActivityIndicatorView()
    lazy var activityIndicatorButton = UIBarButtonItem(customView: activityIndicator)
    let recommandButton = Button(title: "", icon: Images.ButtonIcon.done)
    private let animator = UIViewPropertyAnimator(duration: 7, curve: .easeOut)
    
    let deleteBookButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.ButtonTitle.deleteBook, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        return button
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.roundView(radius: 20, backgroundColor: UIColor.systemPink.withAlphaComponent(0.3))
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image = Images.ButtonIcon.favorite?.withConfiguration(configuration)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.4
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let commentView = BookCardCommentView()
    let bookCover = BookCover(frame: .zero)
    let titleLabel = TextLabel(maxLines: 5,
                               alignment: .center,
                               font: .title)
    let authorLabel = TextLabel(maxLines: 3,
                                alignment: .center,
                                font: .subtitle)
    let categoryiesLabel = TextLabel(color: .secondaryLabel,
                                     maxLines: 2,
                                     alignment: .center,
                                     font: .smallSubtitle)
    let ratingView = RatingView()
    let descriptionLabel = TextLabel(maxLines: 0,
                                     font: .body)
    let bookDetailView = BookDetailView()
    
    private let mainStackView = StackView(axis: .vertical,
                                          spacing: 40)
    
    // MARK: - Configure
    func configure(with model: BookCardUI) {
        titleLabel.text = model.title
        authorLabel.text = model.authors
        ratingView.rating = model.rating ?? 0
        descriptionLabel.text = model.description
        bookDetailView.isbnView.infoLabel.text = model.isbn
        bookDetailView.languageView.infoLabel.text = model.language
        bookDetailView.publisherNameView.infoLabel.text = model.publisher
        bookDetailView.publishedDateView.infoLabel.text = model.publishedDate
        bookDetailView.priceView.infoLabel.text = model.price
        if let pages = model.pages {
            bookDetailView.numberOfPageView.infoLabel.text = String(pages)
        }
        bookCover.getImage(for: model.image) { [weak self] image in
            self?.bookCover.image = image
            self?.backgroundImage.image = image
            self?.animator.startAnimation()
        }
    }
    
    func toggleFavoriteButton(to isFavorite: Bool) {
        favoriteButton.tintColor = isFavorite ? .favoriteColor : .notFavorite
    }
    
    func toggleRecommendButton(to isRecommanding: Bool) {
        let title = isRecommanding ? Text.ButtonTitle.stopRecommending : Text.ButtonTitle.recommend
        recommandButton.setTitle(title, for: .normal)
        commentView.isHidden = !isRecommanding
        isRecommanding ? commentView.animationView.play() : commentView.animationView.stop()
    }

    func showControlButtons(_ isShowing: Bool) {
        deleteBookButton.isHidden = !isShowing
        recommandButton.isHidden = !isShowing
        favoriteButton.isHidden = !isShowing
    }

    private func setupView() {
        bookCover.addShadow()
        toggleRecommendButton(to: false)
        toggleFavoriteButton(to: false)
        let mainStackSubViews: [UIView] = [titleLabel,
                                           authorLabel,
                                           categoryiesLabel,
                                           ratingView,
                                           descriptionLabel,
                                           bookDetailView,
                                           commentView,
                                           recommandButton,
                                           deleteBookButton]
        mainStackSubViews.forEach { mainStackView.addArrangedSubview($0) }
        mainStackView.setCustomSpacing(5, after: titleLabel)
        mainStackView.setCustomSpacing(15, after: authorLabel)
        mainStackView.setCustomSpacing(15, after: categoryiesLabel)
        mainStackView.setCustomSpacing(60, after: ratingView)
        mainStackView.setCustomSpacing(20, after: recommandButton)
    }
    
    private func setImageAnimation() {
        let transformation = CGAffineTransform.identity.scaledBy(x: 1.4, y: 1.4).translatedBy(x: 0, y: -20)
        animator.addAnimations {
            self.backgroundImage.transform = transformation
        }
    }
    
    private func addButtonActions() {
        recommandButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.toggleBookRecommendation()
        }), for: .touchUpInside)
        
        deleteBookButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.presentDeleteBookAlert()
        }), for: .touchUpInside)
        
        favoriteButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.toggleFavoriteBook()
        }), for: .touchUpInside)
        
        commentView.goToCommentButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.presentCommentsViewController()
        }), for: .touchUpInside)
      
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        bookCover.addGestureRecognizer(tap)
    }
  
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        delegate?.displayBookCover()
    }
  
}
// MARK: - Constraints
extension BookCardMainView {
    
    private func setBackgroundImageConstraint() {
        contentView.addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -100),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    private func setScrollViewConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setBookCoverConstraints() {
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bookCover)
        NSLayoutConstraint.activate([
            bookCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            bookCover.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bookCover.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            bookCover.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45)
        ])
    }
    
    private func setFavoriteButtonConstraints() {
        contentView.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.bottomAnchor.constraint(equalTo: bookCover.bottomAnchor, constant: -10),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    /// Setup the mainStackView which hold all the UI subviews.
    private func setupMainstackView() {
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: bookCover.bottomAnchor, constant: 40),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
