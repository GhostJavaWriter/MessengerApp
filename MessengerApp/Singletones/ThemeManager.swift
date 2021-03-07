//
//  ThemeManager.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 05.03.2021.
//

import UIKit

class ThemeManager : ThemesPickerDelegate {
    
    var currentTheme : ThemeOptions?
    
    //MARK: - ThemesPickerDelegate
    
    //Потом разделить код на методы по экранам или просто сгруппировать с комментами
    func setTheme(theme: ThemeOptions) {
        
        currentTheme = theme
        
        //View
        AppView.appearance().backgroundColor = theme.colors.appBgColor
        
        //Labels
        AppLabel.appearance().textColor = theme.colors.mainTextColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = theme.colors.mainTextColor
        UILabel.appearance(whenContainedInInstancesOf: [InboxMessageCell.self]).backgroundColor = theme.colors.inboxMsgBgColor
        UILabel.appearance(whenContainedInInstancesOf: [OutboxMessageCell.self]).backgroundColor = theme.colors.outboxMsgBgColor
        
        //Buttons
        AppButton.appearance().setTitleColor(theme.colors.btnEnabledTitleColor, for: .normal)
        AppButton.appearance().setTitleColor(theme.colors.subviewsTextColor, for: .disabled)
        AppBarButton.appearance().setTitleColor(theme.colors.barButtonColor, for: .normal)
        
        //TableView
        UITableViewCell.appearance().backgroundColor = theme.colors.appBgColor
        UITableView.appearance().backgroundColor = theme.colors.appBgColor
        
        //NavigationBar
        UINavigationBar.appearance().barStyle = theme.navBarStyle
        let titleColor = theme.colors.mainTextColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        UINavigationBar.appearance().tintColor = theme.colors.barButtonColor
        UINavigationBar.appearance().backgroundColor = theme.colors.appBgColor
        
        //AlertController
        
        
        //Reload
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.reload()
    }
}
