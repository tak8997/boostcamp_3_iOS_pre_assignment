//
//  UIAlertController+OrderSettingAction.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

extension UIAlertController {
    // alert controller에 지정된 순서에 따른 alert action 추가
    func addOrderSettingActionByOrder(order: Order?) {
        guard let title: String = order?.getActionName() else { return }
        let action: UIAlertAction = UIAlertAction(title: title, style: .default) { _ in
            OrderType.shared.order = order
            Requests.requestMovieList(order: order, completion: { (_, _) in
            })
        }
        self.addAction(action)
    }
}
