//
//  ThemesViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 05.03.2021.
//

import UIKit

class ThemesViewController: UIViewController {
    
    @objc
    private func cancelSettings() {
        //cancel settings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSettings))
        
    }
    
    

}
