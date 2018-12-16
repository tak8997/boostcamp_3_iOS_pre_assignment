//
//  SectionTitleTableViewCell.swift
//  BoxOffice
//
//  Created by Gaon Kim on 14/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class SectionTitleTableViewCell: UITableViewCell {
    // MARK: - Properties
    // MARK: IBOutlets
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var buttonImageView: UIImageView!

    // MARK: - Methods
    // MARK: Override Methods
    override func prepareForReuse() {
        buttonImageView.image = nil
    }

    // MARK: Custom Methods
    // 한줄평 섹션의 수정 버튼 이미지 활성화
    func setButtonImageEnable() {
        buttonImageView.image = #imageLiteral(resourceName: "btn_compose.png")
        buttonImageView.isUserInteractionEnabled = true
    }
}
