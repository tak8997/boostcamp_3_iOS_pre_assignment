//
//  SynopsisTableViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 13/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class SynopsisTableViewCell: UITableViewCell {
    // MARK: - Properties
    // MARK: IBOutlets
    @IBOutlet weak var synopsisLabel: UILabel!

    // MARK: - Methods
    // MARK: Custom Methods
    func setData(movieDetail: MovieDetail?) {
        synopsisLabel.text = movieDetail?.synopsis
    }
}
