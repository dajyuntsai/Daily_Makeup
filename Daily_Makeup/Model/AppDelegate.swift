//
//  AppDelegate.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/25.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

}

