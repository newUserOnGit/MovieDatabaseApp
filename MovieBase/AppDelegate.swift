//
//  AppDelegate.swift
//  MovieList
//
//  Created by Alexander on 04.04.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        window!.rootViewController = UINavigationController(rootViewController: MainScreenFactory.assembledScreen())
        window!.makeKeyAndVisible()

        return true
    }
}

