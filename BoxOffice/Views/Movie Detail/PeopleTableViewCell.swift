//
//  PeopleTableViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 13/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    // MARK: - Properties
    // MARK: IBOutlets
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!

    // MARK: - Methods
    // MARK: Custom Methods
    func setData(movieDetail: MovieDetail?) {
        directorLabel.text = movieDetail?.director
        actorLabel.text = movieDetail?.actor
    }
}
