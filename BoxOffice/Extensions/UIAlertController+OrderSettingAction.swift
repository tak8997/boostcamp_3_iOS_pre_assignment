//
//  UIAlertController+OrderSettingAction.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addOrderSettingActionByOrder(order: Order?) {
        guard let title: String = order?.getActionName() else { return }
        let action: UIAlertAction = UIAlertAction(title: title, style: .default) { action in
            OrderType.shared.order = order
            Requests.requestMovieList(order: order, completion: nil)
        }
        self.addAction(action)
    }
}
