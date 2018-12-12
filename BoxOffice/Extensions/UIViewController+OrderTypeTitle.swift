//
//  UIViewController+OrderTypeTitle.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

extension UIViewController {
    func setTitle() {
        let order: Order? = OrderType.shared.order
        let title: String? = order?.getTitleName()
        self.title = title
    }
}
