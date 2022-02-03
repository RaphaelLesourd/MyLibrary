//
//  OnboardingViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/01/2022.
//

import UIKit

class OnboardingViewController: UIViewController {

    private let layoutComposer: OnboardingLayoutMaker
    private let mainView = OnboardingMainView()
    private var presenter: OnboardingPresenter

    init(layoutComposer: OnboardingLayoutMaker,
         presenter: OnboardingPresenter) {
        self.layoutComposer = layoutComposer
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        mainView.delegate = self
        configurePageControl()
        configureCollectionView()
    }

    private func configureCollectionView() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        let layout = layoutComposer.makeCollectionViewLayout()
        mainView.collectionView.setCollectionViewLayout(layout, animated: true)
        mainView.collectionView.reloadData()
    }
    
    private func configurePageControl() {
        mainView.pageControl.numberOfPages = Onboarding.pages.count
    }
}

// MARK: - CollectionView Datasource
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Onboarding.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCollectionViewCell = collectionView.dequeue(for: indexPath)
        let model = Onboarding.pages[indexPath.item]
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
        presenter.collectionViewCurrentIndex = index
    }
}

// MARK: - OnboardingView Delegate
extension OnboardingViewController: OnboardingMainViewDelegate {
    func skip() {
        presentWelcomeVC()
    }
    
    func next() {
        presenter.nextButtonTapped()
    }
}
// MARK: - Onboarding presenter
extension OnboardingViewController: OnboardingPresenterView {
    func setLastPageReached(when finished: Bool) {
        mainView.setOnboardingSeen(when: finished)
    }
    
    func scrollCollectionView(to indexPath: IndexPath) {
        mainView.collectionView.scrollToItem(at: indexPath,
                                             at: .centeredHorizontally,
                                             animated: true)
    }
    
    func presentWelcomeVC() {
        self.modalTransitionStyle = .crossDissolve
        dismiss(animated: true)
    }
}
