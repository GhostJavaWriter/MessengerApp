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

extension Array where Element == UIWindow {
    func reload() {
        forEach { $0.reload() }
    }
}
