//
//  ImageScrollView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 19/04/2021.
//

import Foundation
import UIKit

final class ImageScrollView: UIScrollView {

    // MARK: - Properties
    let imageView = UIImageView()
    private var imageViewBottomConstraint = NSLayoutConstraint()
    private var imageViewLeadingConstraint = NSLayoutConstraint()
    private var imageViewTopConstraint = NSLayoutConstraint()
    private var imageViewTrailingConstraint = NSLayoutConstraint()

    // MARK: - Intializer
    required init() {
        super.init(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewLeadingConstraint  = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        imageViewTopConstraint      = imageView.topAnchor.constraint(equalTo: topAnchor)
        imageViewBottomConstraint   = imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        NSLayoutConstraint.activate([imageViewLeadingConstraint,
                                     imageViewTrailingConstraint,
                                     imageViewTopConstraint,
                                     imageViewBottomConstraint])
        
        minimumZoomScale = 2
        maximumZoomScale = 5
        contentInsetAdjustmentBehavior = .never
        showsVerticalScrollIndicator   = false
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal         = true
        alwaysBounceVertical           = true
        delegate                       = self
        
        addDoubleTap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func addDoubleTap() {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if zoomScale == 2 {
            setZoomScale(3, animated: true)
        } else {
            setZoomScale(2, animated: true)
        }
    }
}
// MARK: - UIScrollView Delegate
extension ImageScrollView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let yOffset = max(0, (bounds.size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (bounds.size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        layoutIfNeeded()
    }

}
