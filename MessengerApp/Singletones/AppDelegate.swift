//
//  AppDelegate.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 12.02.2021.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // Aplication moved from <Not running> to <Inactive>
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = ChannelsViewController()
        let themeManager = ThemeManager()
        controller.themeManager = themeManager
        
        let navigationController = UINavigationController(rootViewController: controller)
        
        // Load saved theme if that exist
        let gcdManager = DataManagerGCD()
        gcdManager.loadData(fileName: "theme.json") { (result) in
            switch result {
            case .success(let data):
                parseSavedThemeModel(jsonData: data) { (result) in
                    switch result {
                    case .success(let dictionary):
                        if let savedTheme = dictionary["theme"],
                           let theme = ThemeOptions(rawValue: savedTheme) {
                            DispatchQueue.main.async {
                                themeManager.apply(theme: theme)
                                UIApplication.shared.windows.reload()
                            }
                        }
                        
                    case .failure:
                        themeManager.apply(theme: .classic)
                        UIApplication.shared.windows.reload()
                        NSLog("Theme loading fail. Apply default classic theme")
                    }
                }
                
            case .failure:
                themeManager.apply(theme: .classic)
                UIApplication.shared.windows.reload()
                NSLog("error loading")
            }
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        // Aplication moved from <Active> to <Inactive>
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Aplication moved from <Inactive> to <Background>
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Aplication moved from <Background> to <Inactive>
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Aplication moved from <Inactive> to <Active>
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        // Aplication moved from <Background> to <Suspended>
    }
}
