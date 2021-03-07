//
//  UIWindowExtension.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 07.03.2021.
//

import UIKit

extension UIWindow {
    func reload() {
        subviews.forEach { view in
            view.removeFromSuperview()
            addSubview(view)
        }
    }
}
