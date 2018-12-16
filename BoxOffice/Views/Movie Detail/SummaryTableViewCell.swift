//
//  SummaryTableViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 13/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    // MARK: - Properties
    var delegate: CustomTapGestureDelegate?

    private let numberFormatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    // MARK: IBOutlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var reservationRateLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreAndDuration: UILabel!
    @IBOutlet weak var ratingView: Rating!

    // MARK: - Methods
    // MARK: Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGesture()
    }
    
    // MARK: Override Methods
    override func prepareForReuse() {
        thumbnailImageView.image = #imageLiteral(resourceName: "img_placeholder")
    }

    // MARK: Custom Methods
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
}

// MARK: - Private Extension
private extension SummaryTableViewCell {
    // thumbnailImageView에 tap gesture 연결
    func addTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tappedThumbnailImageView(_:)))
        thumbnailImageView.addGestureRecognizer(tapGesture)
    }
    
    // thumbnailImageView 탭할 경우 delegate method 실행
    // 실행될 method는 MovieDetailViewController에 있음
    @objc func tappedThumbnailImageView(_ sender: UITapGestureRecognizer) {
        delegate?.presentNextViewController()
    }
}

// MARK:- Protocol
// MovieDetailViewcontroller에서 FullScreenPosterViewController를 present 하도록 하는 Protocol
protocol CustomTapGestureDelegate {
    func presentNextViewController()
}
