//
//  SummaryTableViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 13/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    var delegate: CustomTapGestureDelegate?
    
    private let numberFormatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var reservationRateLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreAndDuration: UILabel!
    @IBOutlet weak var ratingView: Rating!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGesture()
    }
    
    func setData(movieDetail: MovieDetail?, thumbnailImage: UIImage?) {
        guard let detail = movieDetail else { return }
        
        thumbnailImageView.image = thumbnailImage
        reservationRateLabel.text = detail.reservationGradeAndRate
        titleLabel.text = detail.title
        releaseDateLabel.text = detail.releaseDate
        genreAndDuration.text = detail.genreAndDuration
        userRatingLabel.text = String(detail.userRating)
        audienceLabel.text = numberFormatter.string(from: NSNumber(integerLiteral: detail.audience))
        ratingView.setRating(rating: detail.userRating)
    }
    
    override func prepareForReuse() {
        thumbnailImageView.image = #imageLiteral(resourceName: "img_placeholder")
    }
}

// MARK:- Private Extension
private extension SummaryTableViewCell {
    func addTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedThumbnailImageView(_:)))
        thumbnailImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tappedThumbnailImageView(_ sender: UITapGestureRecognizer) {
        delegate?.presentNextViewController()
    }

}

// MARK:- Protocol
protocol CustomTapGestureDelegate {
    func presentNextViewController()
}
