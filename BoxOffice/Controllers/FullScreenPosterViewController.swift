//
//  FullScreenPosterViewController.swift
//  BoxOffice
//
//  Created by Gaon Kim on 16/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class FullScreenPosterViewController: UIViewController {

    var image: UIImage?
    var imageUrl: String?
    var scrollView: UIScrollView = UIScrollView()
    var imageView: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        addTapGesture()
        imageView.image = image
    }
}

// MARK: - Private Extension
private extension FullScreenPosterViewController {
    func addScrollView() {
        scrollView = UIScrollView(frame: UIScreen.main.bounds)
        imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.contentMode = .scaleAspectFit
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
    }

    // imageView에 tap gesture 연결
    func addTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tappedImageview(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }

    // imageView 탭할 경우 FullScreenPosterController dismiss
    @objc func tappedImageview(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Scroll View Delegate
extension FullScreenPosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
