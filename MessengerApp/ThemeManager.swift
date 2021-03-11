//
//  ThemeManager.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 05.03.2021.
//

import UIKit

class ThemeManager {
    
    var currentTheme : ThemeOptions?
    
    //MARK: - ThemesPickerDelegate
    
    func apply(theme: ThemeOptions) {
        
        currentTheme = theme
        
        //View
        AppView.appearance().backgroundColor = theme.colors.appBgColor
        AppInboxMessageView.appearance().backgroundColor = theme.colors.inboxMsgBgColor
        AppOutboxMessageView.appearance().backgroundColor = theme.colors.outboxMsgBgColor
        
        //Labels
        AppLabel.appearance().textColor = theme.colors.mainTextColor
        
        //Buttons
        AppButton.appearance().setTitleColor(theme.colors.btnEnabledTitleColor, for: .normal)
        AppButton.appearance().setTitleColor(theme.colors.subviewsTextColor, for: .disabled)
        AppBarButton.appearance().setTitleColor(theme.colors.barButtonColor, for: .normal)
        
        //TableView
        UITableViewCell.appearance().backgroundColor = theme.colors.appBgColor
        UITableView.appearance().backgroundColor = theme.colors.appBgColor
        
        //NavigationBar
        let titleColor = theme.colors.mainTextColor
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        UINavigationBar.appearance().tintColor = theme.colors.barButtonColor
        UINavigationBar.appearance().backgroundColor = theme.colors.appBgColor
        UINavigationBar.appearance().barTintColor = theme.colors.appBgColor
        
        //AlertController
        if #available(iOS 13.0, *) {
            UIView.appearance().overrideUserInterfaceStyle = theme.userInterfaceStyle
        } else {
            NSLog("anavailable -", #function)
        }
    }
}


