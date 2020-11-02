//
//  UIViewController+Alert.swift
//  WeatherJapan
//
//  Created by 金宝ヨン on 2020/11/02.
//  Copyright © 2020 kimjinyoung. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(message: String) {
        let alert = UIAlertController(title: "알림", message: message,
                                      preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
}
