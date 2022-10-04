//
//  AppDelegate.swift
//  Unsplash
//
//  Created by Tommy Yon Prakoso on 08/07/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: HomePageViewController())
        window?.makeKeyAndVisible()
        return true
    }
}
