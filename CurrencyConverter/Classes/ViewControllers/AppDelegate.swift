//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appCoordinator : Coordinator!
    //var navigationController : UINavigationController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // set the rootViewController
        appCoordinator = CoordinatorFactory.getAppCoordinator()
        window?.rootViewController = appCoordinator.router.toPresent()

        return true
    }


}

