//
//  UIViewController+OrderTypeTitle.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

extension UIViewController {
    // 정렬 순서에 따른 navigation title 설정
    func setNavigationTitleByOrder() {
        let order: Order? = OrderType.shared.order
        let title: String? = order?.getTitleName()
        navigationItem.title = title
    }
}
