//
//  Rating.swift
//  BoxOffice
//
//  Created by Gaon Kim on 16/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class Rating: UIStackView {

    private var rating: Double = 0
    private var starCount: Int {
        return Int(lround(rating))
    }

    func setRating(rating: Double) {
        self.rating = rating
        
        var count: Int = starCount
        for (_, ratingSubView) in arrangedSubviews.enumerated() {
            guard let imageView: UIImageView = ratingSubView as? UIImageView else { return }
            
            if count >= 2 { imageView.image = #imageLiteral(resourceName: "ic_star_large_full") }
            else if count == 1 { imageView.image = #imageLiteral(resourceName: "ic_star_large_half")}
            else { imageView.image = #imageLiteral(resourceName: "ic_star_large") }
            count -= 2
        }
    }
}
