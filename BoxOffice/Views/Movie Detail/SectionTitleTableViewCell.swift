//
//  SectionTitleTableViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 14/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class SectionTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var buttonImageView: UIImageView!
    
    override func prepareForReuse() {
        buttonImageView.image = nil
    }
    
    func setButtonImageEnable() {
        buttonImageView.image = #imageLiteral(resourceName: "btn_compose.png")
        buttonImageView.isUserInteractionEnabled = true
    }
}
