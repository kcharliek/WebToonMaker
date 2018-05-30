//
//  AppDelegate.swift
//  WebToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 17..
//  Copyright © 2018년 CHK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureUI()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func configureUI() {
        UINavigationBar.appearance().barTintColor = TMColor.primaryColor
        UINavigationBar.appearance().tintColor = Color.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: Color.white]
        UINavigationBar.appearance().isTranslucent = false
    }

}
