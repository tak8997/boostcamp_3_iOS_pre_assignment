//
//  MovieTableViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    func setData(movie: Movie) {
        titleLabel.text = movie.title
        informationLabel.text = movie.informationForTable
        releaseDateLabel.text = movie.releaseDate
        gradeImageView.image = UIImage(named: movie.gradeImage)
        
        setThumbnailImage(imgUrlString: movie.thumb)
    }
}

// MARK:- Private Extension
private extension MovieTableViewCell {
    func setThumbnailImage(imgUrlString: String) {
        Requests.requestImage(imageUrl: imgUrlString) { image in
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }
}
