//
//  CommentsTableViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 13/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    // MARK: - Properties
    private let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    // MARK: IBOutlets
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ratingView: Rating!

    // MARK: - Methods
    // MARK: Custom Methods
    func setData(comment: Comment) {
        idLabel.text = comment.writer
        contentLabel.text = comment.contents

        let date: Date = Date(timeIntervalSince1970: comment.timestamp)
        timeLabel.text = dateFormatter.string(for: date)
        ratingView.setRating(rating: comment.rating)
    }
}
