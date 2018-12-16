//
//  MovieCollectionViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    private var id: String?

    // MARK: IBOutlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!

    // MARK: - Methods
    // MARK: Override Methods
    override func prepareForReuse() {
        thumbnailImageView.image = #imageLiteral(resourceName: "img_placeholder")
        ageImageView.image = nil
    }

    // MARK: Custom Methods
    func setData(movie: Movie) {
        ageImageView.image = UIImage(named: movie.gradeImage)
        titleLabel.text = movie.title
        informationLabel.text = movie.informationForCollection
        releaseDateLabel.text = movie.date
        id = movie.id

        setThumbnailImage(imgUrlString: movie.thumb)
    }

    func getId() -> String? {
        return id
    }
}

private extension MovieCollectionViewCell {
    func setThumbnailImage(imgUrlString: String) {
        Requests.requestImage(imageUrl: imgUrlString) { [weak self] image in
            self?.thumbnailImageView.image = image
        }
    }
}
