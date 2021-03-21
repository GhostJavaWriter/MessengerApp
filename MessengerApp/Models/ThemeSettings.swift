//
//  ThemeSettings.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 05.03.2021.
//

import UIKit

struct ThemeSettings {
    
    let appBgColor : UIColor
    let inboxMsgBgColor : UIColor
    let outboxMsgBgColor : UIColor
    let mainTextColor : UIColor
    let btnEnabledTitleColor : UIColor
    let subviewsTextColor : UIColor
    let barButtonColor : UIColor
    
}

extension ThemeSettings {
    
    static let classicTheme = ThemeSettings(appBgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                            inboxMsgBgColor: #colorLiteral(red: 0.9176470588, green: 0.9215686275, blue: 0.9294117647, alpha: 1),
                                            outboxMsgBgColor: #colorLiteral(red: 0.8313642144, green: 0.9748910069, blue: 0.7519891858, alpha: 1),
                                            mainTextColor: .black,
                                            btnEnabledTitleColor: .systemBlue,
                                            subviewsTextColor: .systemGray,
                                            barButtonColor: .systemBlue)
    
    static let dayTheme = ThemeSettings(appBgColor: .white,
                                        inboxMsgBgColor: #colorLiteral(red: 0.9165825248, green: 0.9216925502, blue: 0.9301533699, alpha: 1),
                                        outboxMsgBgColor: #colorLiteral(red: 0.09246445447, green: 0.5374064445, blue: 1, alpha: 1),
                                        mainTextColor: .black,
                                        btnEnabledTitleColor: .systemBlue,
                                        subviewsTextColor: .systemGray,
                                        barButtonColor: .systemBlue)
    
    static let nightTheme = ThemeSettings(appBgColor: #colorLiteral(red: 0.1182499751, green: 0.1221381798, blue: 0.1246878579, alpha: 1),
                                          inboxMsgBgColor: #colorLiteral(red: 0.1803726256, green: 0.1804046035, blue: 0.180365622, alpha: 1),
                                          outboxMsgBgColor: #colorLiteral(red: 0.3607498407, green: 0.3608062863, blue: 0.3607374728, alpha: 1),
                                          mainTextColor: .white,
                                          btnEnabledTitleColor: .systemBlue,
                                          subviewsTextColor: .systemGray,
                                          barButtonColor: .white)
}

enum ThemeOptions : String {
    
    case classic = "classic"
    case day = "day"
    case night = "night"
    var colors : ThemeSettings {
        switch self {
        case .classic : return ThemeSettings.classicTheme
        case .day : return ThemeSettings.dayTheme
        case .night : return ThemeSettings.nightTheme
        }
    }
    var navBarStyle : UIBarStyle {
        switch self {
        case .classic : return .default
        case .day : return .default
        case .night : return .blackOpaque
        }
    }
    
    var userInterfaceStyle : UIUserInterfaceStyle {
        switch self {
        case .classic:
            return .light
        case .day:
            return .light
        case .night:
            return .dark
        }
    }
}

enum Keys {
    static let selectedTheme = "SelectedTheme"
}
