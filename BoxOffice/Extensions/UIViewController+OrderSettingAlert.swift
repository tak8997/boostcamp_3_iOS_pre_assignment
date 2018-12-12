//
//  UIViewController+OrderSettingAlert.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

extension UIViewController {
    func addOrderSettingAlert() {
        let title: String = "정렬 방식 선택"
        let message: String = "어떤 방식으로 정렬할까요?"
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addOrderSettingAction(order: Order.reservationRate)
        alert.addOrderSettingAction(order: Order.curation)
        alert.addOrderSettingAction(order: Order.releaseDate)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
