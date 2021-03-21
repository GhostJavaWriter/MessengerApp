//
//  ThemesViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 05.03.2021.
//

import UIKit

class ThemesViewController: UIViewController {
    
    weak var themesPickerDelegate : ThemesPickerDelegate?
    
    var currentTheme : ThemeOptions?
    
    //MARK: - UI
    
    //rename the buttons
    @IBOutlet weak var classicThemeView: UIView!
    @IBOutlet weak var classicLabel: UILabel!
    @IBOutlet weak var dayThemeView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nightThemeView: UIView!
    @IBOutlet weak var nightLabel: UILabel!
    
    //MARK: - Private
    
    @objc
    private func cancelSettings() {
        
        themesPickerDelegate?.apply(theme: .classic)
        applyToCurrentScreen(theme: .classic, buttonView: classicThemeView)
    }
    
    @objc
    private func setClassicTheme() {
        
        themesPickerDelegate?.apply(theme: .classic)
        
        applyToCurrentScreen(theme: .classic, buttonView: classicThemeView)
    }
    
    @objc
    private func setDayTheme() {
        
        themesPickerDelegate?.apply(theme: .day)
        
        applyToCurrentScreen(theme: .day, buttonView: dayThemeView)
    }
    
    @objc
    private func setNightTheme() {
        
        themesPickerDelegate?.apply(theme: .night)
        
        applyToCurrentScreen(theme: .night, buttonView: nightThemeView)
    }
    
    private func applyToCurrentScreen(theme: ThemeOptions, buttonView: UIView) {
        
        UIApplication.shared.windows.reload()
        
        repaintSelectedView(selectedButton: buttonView)
        
        let gcdSaver = DataManagerGCD()
        gcdSaver.saveCurrentTheme(theme: theme, fileName: "theme.json") { (result) in
            switch result {
            case .success(let result):
                print("is saved? - ", result)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    private func configureGestureRecognizers() {
        
        let classicBtnTapped = UITapGestureRecognizer(target: self, action: #selector(setClassicTheme))
        classicThemeView.addGestureRecognizer(classicBtnTapped)
        
        let classicLabelTapped = UITapGestureRecognizer(target: self, action: #selector(setClassicTheme))
        classicLabel.addGestureRecognizer(classicLabelTapped)
        
        let dayButtonTapped = UITapGestureRecognizer(target: self, action: #selector(setDayTheme))
        dayThemeView.addGestureRecognizer(dayButtonTapped)
        
        let dayLabelTapped = UITapGestureRecognizer(target: self, action: #selector(setDayTheme))
        dayLabel.addGestureRecognizer(dayLabelTapped)
        
        let nightButtonTapped = UITapGestureRecognizer(target: self, action: #selector(setNightTheme))
        nightThemeView.addGestureRecognizer(nightButtonTapped)
        
        let nightLabelTapped = UITapGestureRecognizer(target: self, action: #selector(setNightTheme))
        nightLabel.addGestureRecognizer(nightLabelTapped)
    }
    
    private func repaintSelectedView(selectedButton: UIView) {
        
        classicThemeView.layer.borderColor = UIColor.lightGray.cgColor
        dayThemeView.layer.borderColor = UIColor.lightGray.cgColor
        nightThemeView.layer.borderColor = UIColor.lightGray.cgColor
        
        selectedButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        classicThemeView.layer.borderWidth = 2
        dayThemeView.layer.borderWidth = 2
        nightThemeView.layer.borderWidth = 2
        
        classicThemeView.layer.cornerRadius = 14
        dayThemeView.layer.cornerRadius = 14
        nightThemeView.layer.cornerRadius = 14
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSettings))
        
        switch currentTheme {
        case .classic:
            repaintSelectedView(selectedButton: classicThemeView)
        case .day:
            repaintSelectedView(selectedButton: dayThemeView)
        case .night:
            repaintSelectedView(selectedButton: nightThemeView)
        default:
            repaintSelectedView(selectedButton: classicThemeView)
        }
        
        configureGestureRecognizers()
    }
    
    
}
