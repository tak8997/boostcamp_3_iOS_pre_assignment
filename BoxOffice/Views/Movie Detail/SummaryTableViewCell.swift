//
//  SummaryTableViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 13/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var reservationRateLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreAndDuration: UILabel!
    
    func setData(movieDetail: MovieDetail?, thumbnailImage: UIImage?) {
        thumbnailImageView.image = thumbnailImage
        reservationRateLabel.text = movieDetail?.reservationGradeAndRate
        titleLabel.text = movieDetail?.title
        releaseDateLabel.text = movieDetail?.releaseDate
        genreAndDuration.text = movieDetail?.genreAndDuration
        
        if let userRating = movieDetail?.userRating {
            userRatingLabel.text = String(userRating)
        }
        
        let numberFormatter: NumberFormatter = {
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
        
        if let audience = movieDetail?.audience {
            audienceLabel.text = numberFormatter.string(from: NSNumber(integerLiteral: audience))
        }
    }
}
