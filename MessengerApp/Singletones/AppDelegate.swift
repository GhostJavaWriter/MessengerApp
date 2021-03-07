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
        
        themeManager.currentTheme = ThemeOptions.classic
        themeManager.setTheme(theme: ThemeOptions.classic)
        
        controller.themeManager = themeManager
        
        let navigationController = UINavigationController(rootViewController: controller)
        
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
