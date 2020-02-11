//
//  SinginViewController.swift
//  Daily_Makeup
//
//  Created by Hueijyun  on 2020/2/3.
//  Copyright © 2020 Hueijyun . All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class SinginViewController: UIViewController {
    
    var db: Firestore!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(success), name: Notification.Name("success"), object: nil)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        db = Firestore.firestore()
    }
    
    @objc func success() {
        guard let home = storyboard?.instantiateViewController(identifier: "tabBarController") as? UITabBarController else { return }
        
        self.view.window?.rootViewController = home
        
//        self.present(home, animated: true, completion: nil)
    }
    
    @IBAction func fbsigninButton(_ sender: UIButton) {
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                //                user?.user.refreshToken
                guard let uid = user?.user.uid, let name = user?.user.displayName, let email = user?.user.email else { return }
    
                self.userDefaults.setValue(name, forKey: "name")
                self.userDefaults.setValue(email, forKey: "email")
                self.userDefaults.setValue(uid, forKey: "uid")
                
                
                let signInID = SignID (
                    name: name,
                    email: email,
                    uid: uid
                    )
                
                do {
                    try self.db.collection("user").document(uid).setData(from: signInID, merge: true)
                } catch {
                    print(error)
                }
                
                // Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") {
                    
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    appDelegate.window?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }
    }
    
    
    @IBAction func googleSignin(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
//                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") {
//
//                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//                appDelegate.window?.rootViewController = viewController
//                self.dismiss(animated: true, completion: nil)
//                }
    }
    
}

