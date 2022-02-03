//
//  ImageScrollView.swift
//  MyLibrary
//
//  Created by Birkyboy on 15/11/2021.
//

import UIKit

final class ImageScrollView: UIScrollView {

    // MARK: - Properties
    let imageView = UIImageView()
    private var imageViewBottomConstraint = NSLayoutConstraint()
    private var imageViewLeadingConstraint = NSLayoutConstraint()
    private var imageViewTopConstraint = NSLayoutConstraint()
    private var imageViewTrailingConstraint = NSLayoutConstraint()

    // MARK: - Intializer
    init() {
        super.init(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: topAnchor)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        NSLayoutConstraint.activate([imageViewLeadingConstraint,
                                     imageViewTrailingConstraint,
                                     imageViewTopConstraint,
                                     imageViewBottomConstraint])
        
        self.minimumZoomScale = 0.5
        self.maximumZoomScale = 5
        self.contentInsetAdjustmentBehavior = .never
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = true
        self.delegate = self
        
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
        if zoomScale == minimumZoomScale {
            setZoomScale(1.3, animated: true)
        } else {
            setZoomScale(minimumZoomScale, animated: true)
        }
    }
    
    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
          let scrollViewSize = bounds.size
          let widthScale = scrollViewSize.width / imageViewSize.width
          let heightScale = scrollViewSize.height / imageViewSize.height

          let minZoomScale = min(widthScale, heightScale)
          minimumZoomScale = minZoomScale
          zoomScale = minZoomScale
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
