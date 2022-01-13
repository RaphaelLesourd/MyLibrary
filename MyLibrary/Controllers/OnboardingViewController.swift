//
//  OnboardingViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/01/2022.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    private let layoutComposer: OnboardingLayoutComposer
    private let mainView = OnboardingMainView()
    private let onboardingData: [Onboarding] = [Onboarding(image: Images.Onboarding.referencing,
                                                           title: Text.Onboarding.referenceBookTitle,
                                                           subtitle: Text.Onboarding.referenceBookSubtitle),
                                                Onboarding(image: Images.Onboarding.searching,
                                                           title: Text.Onboarding.searchBookTitle,
                                                           subtitle: Text.Onboarding.searchBookSubtitle),
                                                Onboarding(image: Images.Onboarding.sharing,
                                                           title: Text.Onboarding.shareBookTitle,
                                                           subtitle: Text.Onboarding.shareBookSubtitle)]
    private var collectionViewcurrentIndex = 0 {
        didSet {
            updatePageNumber(with: collectionViewcurrentIndex)
        }
    }
    // MARK: - Intializer
    init(layoutComposer: OnboardingLayoutComposer) {
        self.layoutComposer = layoutComposer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        configurePageControl()
        configureCollectionView()
    }
    
    // MARK: - Setup
    private func configureCollectionView() {
        mainView.collectionView.register(cell: OnboardingCollectionViewCell.self)
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        let layout = layoutComposer.setCollectionViewLayout()
        mainView.collectionView.setCollectionViewLayout(layout, animated: true)
        mainView.collectionView.reloadData()
    }
    
    private func configurePageControl() {
        mainView.pageControl.numberOfPages = onboardingData.count
    }
    
    // MARK: - Update
    private func updatePageNumber(with index: Int) {
        let lastPageReached = index == onboardingData.count - 1
        mainView.onboardingCompleted(lastPageReached)
    }
    
    private func presentWelcomeViewController() {
        UserDefaults.standard.set(true, forKey: UserDefaultKey.onboardingSeen.rawValue)
        self.modalTransitionStyle = .crossDissolve
        dismiss(animated: true)
    }
}
// MARK: - CollectionView Datasource
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCollectionViewCell = collectionView.dequeue(for: indexPath)
        let model = onboardingData[indexPath.item]
        cell.configure(with: model)
        return cell
    }
}
// MARK: - CollectionView Delegate
extension OnboardingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let visible = collectionView.visibleCells.first else { return }
        guard let index = collectionView.indexPath(for: visible)?.row else { return }
        mainView.pageControl.currentPage = index
        collectionViewcurrentIndex = index
    }
}

// MARK: - OnboardingViewDelegate
extension OnboardingViewController: OnboardingMainViewDelegate {
    
    func skip() {
        presentWelcomeViewController()
    }
    
    func next() {
        if collectionViewcurrentIndex < onboardingData.count - 1 {
            collectionViewcurrentIndex += 1
            let indexPath = IndexPath(item: collectionViewcurrentIndex, section: 0)
            mainView.collectionView.scrollToItem(at: indexPath,
                                                 at: .centeredHorizontally,
                                                 animated: true)
        } else {
            presentWelcomeViewController()
        }
    }
}
