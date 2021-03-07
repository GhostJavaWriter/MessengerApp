//
//  ThemesViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 05.03.2021.
//

import UIKit

class ThemesViewController: UIViewController {
    
    var themesPickerDelegate : ThemesPickerDelegate?
    var themeManager : ThemeManager?
    
    //MARK: - UI
    
    @IBOutlet weak var classicButton: UIView!
    @IBOutlet weak var classicLabel: UILabel!
    @IBOutlet weak var dayButton: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nightButton: UIView!
    @IBOutlet weak var nightLabel: UILabel!
    
    //MARK: - Private
    
    @objc
    private func cancelSettings() {
        //cancel settings
    }
    
    @objc
    private func setClassicTheme() {
        
        themesPickerDelegate?.setTheme(theme: ThemeOptions.classic)
        setButtonBorderColor(theme: ThemeOptions.classic)
        setDefaultBtnStyle()
        classicButton.layer.borderWidth = 2
        classicButton.layer.borderColor = UIColor.blue.cgColor
    }
    
    @objc
    private func setDayTheme() {
        
        themesPickerDelegate?.setTheme(theme: ThemeOptions.day)
        setButtonBorderColor(theme: ThemeOptions.day)
        setDefaultBtnStyle()
        dayButton.layer.borderWidth = 2
        dayButton.layer.borderColor = UIColor.blue.cgColor
    }
    
    @objc
    private func setNightTheme() {
        
        themesPickerDelegate?.setTheme(theme: ThemeOptions.night)
        setButtonBorderColor(theme: ThemeOptions.night)
        setDefaultBtnStyle()
        nightButton.layer.borderWidth = 2
        nightButton.layer.borderColor = UIColor.blue.cgColor
    }
    
    private func setButtonBorderColor(theme: ThemeOptions) {
        
        switch theme {
        case .classic:
            classicButton.layer.borderColor = UIColor.systemBlue.cgColor
        case .day:
            dayButton.layer.borderColor = UIColor.systemBlue.cgColor
        case .night:
            nightButton.layer.borderColor = UIColor.systemBlue.cgColor
        }
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
    
    private func setDefaultBtnStyle() {
        
        classicButton.layer.borderWidth = 2
        dayButton.layer.borderWidth = 2
        nightButton.layer.borderWidth = 2
        
        classicButton.layer.borderColor = UIColor.lightGray.cgColor
        dayButton.layer.borderColor = UIColor.lightGray.cgColor
        nightButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let themeManager = ThemeManager()
        themesPickerDelegate = themeManager
        
        
        
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSettings))
        
        setDefaultBtnStyle()
        
        configureGestureRecognizers()
    }
    
}
