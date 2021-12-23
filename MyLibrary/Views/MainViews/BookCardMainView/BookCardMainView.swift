//
//  BookCardMainView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import Lottie

protocol BookCardMainViewDelegate: AnyObject {
    func recommandButtonAction()
    func editBook()
    func deleteBookAction()
    func favoriteButtonAction()
    func showComments()
    func showBookCover()
}

class BookCardMainView: UIView {
    
    private var converter: ConverterProtocol
    private var formatter: FormatterProtocol
    weak var delegate: BookCardMainViewDelegate?
    
    // MARK: - Initializers
    init(frame: CGRect, converter: ConverterProtocol, formatter: FormatterProtocol) {
        self.converter = converter
        self.formatter = formatter
        super.init(frame: .zero)
        setTargets()
        setScrollViewConstraints()
        setBackgroundImageConstraint()
        setBookCoverConstraints()
        setupMainstackView()
        setFavoriteButtonConstraints()
        bookCover.addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        backgroundImage.addFadeGradient()
    }
    
    // MARK: - Subviews
    let activityIndicator = UIActivityIndicatorView()
    let editButton = UIBarButtonItem(image: Images.NavIcon.editBookIcon,
                                     style: .plain,
                                     target: self,
                                     action: #selector(editBook))
    lazy var activityIndicatorButton = UIBarButtonItem(customView: activityIndicator)
    let recommandButton = Button(title: "")
    let deleteBookButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.ButtonTitle.deleteBook, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return button
    }()
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.rounded(radius: 20, backgroundColor: UIColor.systemPink.withAlphaComponent(0.3))
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
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.55
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let commentView = BookCardCommentView()
    private let bookCover = BookCover(frame: .zero)
    private let titleLabel = TextLabel(maxLines: 5, alignment: .center, fontSize: 21, weight: .semibold)
    private let authorLabel = TextLabel(maxLines: 3, alignment: .center, fontSize: 16, weight: .regular)
    private let categoryiesLabel = TextLabel(color: .secondaryLabel, maxLines: 2, alignment: .center, fontSize: 13, weight: .medium)
    private let ratingView = RatingView()
    private let descriptionLabel = TextLabel(maxLines: 0, fontSize: 16, weight: .light)
    private let purchaseDetailView = PriceView()
    private let bookDetailView = BookDetailView()
    private let isbnLabel = TextLabel(color: .secondaryLabel)
    private let mainStackView = StackView(axis: .vertical, spacing: 30)
    
    // MARK: - Configure
    func displayBookInfos(with book: Item?) {
        titleLabel.text = book?.volumeInfo?.title?.capitalized
        authorLabel.text = book?.volumeInfo?.authors?.first?.capitalized
        ratingView.rating = book?.volumeInfo?.ratingsCount ?? 0
        descriptionLabel.text = book?.volumeInfo?.volumeInfoDescription
        
        bookDetailView.publisherNameView.infoLabel.text = book?.volumeInfo?.publisher?.capitalized
        bookDetailView.publishedDateView.infoLabel.text = book?.volumeInfo?.publishedDate
        bookDetailView.numberOfPageView.infoLabel.text = "\(book?.volumeInfo?.pageCount ?? 0)"
        
        if let isbn = book?.volumeInfo?.industryIdentifiers?.first?.identifier {
            isbnLabel.text = Text.Book.isbn + isbn
        }
        
        purchaseDetailView.titleLabel.text = Text.Book.price
        let currency = book?.saleInfo?.retailPrice?.currencyCode
        let price = book?.saleInfo?.retailPrice?.amount
        purchaseDetailView.purchasePriceLabel.text = formatter.formatDoubleToPrice(with: price, currencyCode: currency)
        bookDetailView.languageView.infoLabel.text = formatter.formatCodeToName(from: book?.volumeInfo?.language,
                                                                                 type: .language).capitalized
    }
    
    func configureBookCoverImage(with image: UIImage) {
        bookCover.image = image
        backgroundImage.image = image
        let transformation = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2).translatedBy(x: 0, y: -10)
        UIView.animate(withDuration: 7, delay: 0, options: [.curveEaseOut, .allowUserInteraction, .preferredFramesPerSecond60]) {
            self.backgroundImage.transform = transformation
        }
    }
    
    func displayCategories(with categoryNames: [String]) {
        categoryiesLabel.text = converter.convertArrayToString(categoryNames).uppercased()
    }
    
    func setFavoriteButtonAs(_ isFavorite: Bool) {
        favoriteButton.tintColor = isFavorite ? .favoriteColor : .notFavorite
    }
    
    func setRecommandedButtonAs(_ isRecommanding: Bool) {
        let title = isRecommanding ? Text.ButtonTitle.stopRecommending : Text.ButtonTitle.recommend
        recommandButton.setTitle(title, for: .normal)
        commentView.isHidden = !isRecommanding
        isRecommanding ? commentView.animationView.play() : commentView.animationView.stop()
    }
    
    private func setTargets() {
        recommandButton.addTarget(self, action: #selector(recommandBook), for: .touchUpInside)
        deleteBookButton.addTarget(self, action: #selector(deleteBook), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteBook), for: .touchUpInside)
        commentView.goToCommentButton.addTarget(self, action: #selector(showBookComments), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        bookCover.addGestureRecognizer(tap)
    }
    
    // MARK: - Targets
    @objc private func recommandBook() {
        delegate?.recommandButtonAction()
    }
    
    @objc private func editBook() {
        delegate?.editBook()
    }
    
    @objc private func deleteBook() {
        delegate?.deleteBookAction()
    }
    
    @objc private func favoriteBook() {
        delegate?.favoriteButtonAction()
    }
    
    @objc private func showBookComments() {
        delegate?.showComments()
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        delegate?.showBookCover()
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
            bookCover.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            bookCover.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
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
        let mainStackSubViews: [UIView] = [titleLabel,
                                           authorLabel,
                                           categoryiesLabel,
                                           ratingView,
                                           descriptionLabel,
                                           bookDetailView,
                                           isbnLabel,
                                           purchaseDetailView,
                                           commentView,
                                           recommandButton,
                                           deleteBookButton]
        mainStackSubViews.forEach { mainStackView.addArrangedSubview($0) }
        mainStackView.setCustomSpacing(5, after: titleLabel)
        mainStackView.setCustomSpacing(10, after: authorLabel)
        mainStackView.setCustomSpacing(15, after: categoryiesLabel)
        mainStackView.setCustomSpacing(50, after: ratingView)
        mainStackView.setCustomSpacing(20, after: bookDetailView)
        mainStackView.setCustomSpacing(5, after: deleteBookButton)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: bookCover.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
