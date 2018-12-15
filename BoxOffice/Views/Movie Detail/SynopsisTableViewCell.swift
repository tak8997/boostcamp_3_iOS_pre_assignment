//
//  SynopsisTableViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 13/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class SynopsisTableViewCell: UITableViewCell {
    @IBOutlet weak var synopsisLabel: UILabel!
    
    func setData(movieDetail: MovieDetail?) {
        synopsisLabel.text = movieDetail?.synopsis
    }
}
