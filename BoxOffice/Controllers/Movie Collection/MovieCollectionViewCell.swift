//
//  MovieCollectionViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var ageImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var informationLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    
    override func prepareForReuse() {
        thumbnailImageView.image = #imageLiteral(resourceName: "img_placeholder")
    }
    
    func setData(movie: Movie) {
        ageImageView.image = UIImage(named: movie.gradeImage)
        titleLabel.text = movie.title
        informationLabel.text = movie.informationForCollection
        releaseDateLabel.text = movie.date
        
        setThumbnailImage(imgUrlString: movie.thumb)
    }
}

private extension MovieCollectionViewCell {
    func setThumbnailImage(imgUrlString: String) {
        Requests.requestImage(imageUrl: imgUrlString) { image in
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }
}
