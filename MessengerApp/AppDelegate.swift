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
        
        //You can switch off this over here - OS_ACTIVITY_MODE
        NSLog("Aplication moved from <Not running> to <Inactive> : " + #function)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        NSLog("Aplication moved from <Active> to <Inactive> : " + #function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        NSLog("Aplication moved from <Inactive> to <Background> : " + #function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        NSLog("Aplication moved from <Background> to <Inactive> : " + #function)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        NSLog("Aplication moved from <Inactive> to <Active> : " + #function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        NSLog("Aplication moved from <Background> to <Suspended> : " + #function)
    }
}
