//
//  UIViewController+OrderSettingAlert.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

extension UIViewController {
    // 정렬 순서에 따른 action이 추가된 alert controller를 추가
    func addOrderSettingAlert() {
        let title: String = "정렬 방식 선택"
        let message: String = "어떤 방식으로 정렬할까요?"
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addOrderSettingActionByOrder(order: Order.reservationRate)
        alert.addOrderSettingActionByOrder(order: Order.curation)
        alert.addOrderSettingActionByOrder(order: Order.releaseDate)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}
