//
//  UViewController+ErrorAlert.swift
//  BoxOffice
//
//  Created by Gaon Kim on 16/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(actionTitle: String, actionHandler: (()->Void)?) {
        let alert: UIAlertController = UIAlertController(title: "네트워크 오류", message: "네트워크 오류가 발생했습니다.\n다시 시도해주세요.", preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: actionTitle, style: .destructive) { action in
            actionHandler?()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
