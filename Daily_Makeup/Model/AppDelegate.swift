//
//  AppDelegate.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/1/25.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FirebaseFirestore
import JGProgressHUD

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        IQKeyboardManager.shared.enable = true
        
        return true
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("error")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { ( user, error) in
            if let error = error {
                print("error")
                return
            }
            guard let uid = user?.user.uid,
                let name = user?.user.displayName,
                let email = user?.user.email,
                let image = user?.user.photoURL?.absoluteString else { return }
            
            
            let size = "?width=400&height=400"
            let picture = "\(image + size)"
            
            let signInID = SignID (
                name: name,
                email: email,
                uid: uid
//                image: picture
            )
            let userDefaults = UserDefaults.standard
            let db = Firestore.firestore()
            
            userDefaults.set(name, forKey: "name")
            userDefaults.set(email, forKey: "email")
            userDefaults.set(uid, forKey: "uid")
//            userDefaults.set(picture, forKey: "image")
            
            do {
                try db.collection("user").document(uid).setData(from: signInID, merge: true)
            } catch {
                print(error)
            }
            NotificationCenter.default.post(name: Notification.Name("success"), object: nil)
            //            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            //            appDelegate.window?.rootViewController = viewController
            //
            
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    var window: UIWindow?
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    
}

