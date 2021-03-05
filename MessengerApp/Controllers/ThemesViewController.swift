//
//  ThemesViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 05.03.2021.
//

import UIKit

class ThemesViewController: UIViewController {
    
    @IBOutlet weak var classicButton: UIView!
    @IBOutlet weak var classicLabel: UILabel!
    @IBOutlet weak var dayButton: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nightButton: UIView!
    @IBOutlet weak var nightLabel: UILabel!
    
    @objc
    private func cancelSettings() {
        //cancel settings
    }
    
    @objc
    private func setClassicTheme() {
        print("classic")
    }
    
    @objc
    private func setDayTheme() {
        print("day")
    }
    
    @objc
    private func setNightTheme() {
        print("night")
    }
    
    private func configureGestureRecognizers() {
        
        let classicBtnTapped = UITapGestureRecognizer(target: self, action: #selector(setClassicTheme))
        classicButton.addGestureRecognizer(classicBtnTapped)
        
        let classicLabelTapped = UITapGestureRecognizer(target: self, action: #selector(setClassicTheme))
        classicLabel.addGestureRecognizer(classicLabelTapped)
        
        let dayButtonTapped = UITapGestureRecognizer(target: self, action: #selector(setDayTheme))
        dayButton.addGestureRecognizer(dayButtonTapped)
        
        let dayLabelTapped = UITapGestureRecognizer(target: self, action: #selector(setDayTheme))
        dayLabel.addGestureRecognizer(dayLabelTapped)
        
        let nightButtonTapped = UITapGestureRecognizer(target: self, action: #selector(setNightTheme))
        nightButton.addGestureRecognizer(nightButtonTapped)
        
        let nightLabelTapped = UITapGestureRecognizer(target: self, action: #selector(setNightTheme))
        nightLabel.addGestureRecognizer(nightLabelTapped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSettings))
        
        configureGestureRecognizers()
    }
}
