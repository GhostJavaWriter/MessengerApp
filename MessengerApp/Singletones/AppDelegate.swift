//
//  AppDelegate.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 12.02.2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Aplication moved from <Not running> to <Inactive>
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = ConversationsListViewController()
        let themeManager = ThemeManager()
        controller.themeManager = themeManager
        
        let navigationController = UINavigationController(rootViewController: controller)
        
        let userDefaults = UserDefaults.standard
        if let rowValue = userDefaults.object(forKey: Keys.selectedTheme) as? String,
           let theme = ThemeOptions(rawValue: rowValue) {
            themeManager.apply(theme: theme)
        } else {
            themeManager.apply(theme: .classic)
            NSLog("Theme loading fail. Apply default classic theme")
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        //Aplication moved from <Active> to <Inactive>
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        //Aplication moved from <Inactive> to <Background>
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        //Aplication moved from <Background> to <Inactive>
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        //Aplication moved from <Inactive> to <Active>
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        //Aplication moved from <Background> to <Suspended>
    }
}
