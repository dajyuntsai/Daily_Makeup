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
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import CryptoKit
import AuthenticationServices

@available(iOS 13.0, *)
class SinginViewController: UIViewController {
    
    var database: Firestore!
    var uid = ""
    var name = ""
    @IBOutlet var appleSignin: UIView!
    
    let appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.cornerRadius = 22.5
        if #available(iOS 13, *) {
            button.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        return button
        
    }()
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(currentNonce!)
        
        print("----", sha256(currentNonce!))
        print("----", currentNonce!)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //google signin
        NotificationCenter.default.addObserver(self, selector: #selector(success), name: Notification.Name("success"), object: nil)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        database = Firestore.firestore()
        
        //        appleButton = ASAuthorizationAppleIDButton()
        view.layoutIfNeeded()
        
        //        appleButton.addTarget(self, action: #selector(startSignInWithAppleFlow) , for: .touchUpInside)
        appleButton.frame = CGRect(x: 0, y: 0, width: appleSignin.frame.width, height: appleSignin.frame.height)
        appleSignin.addSubview(appleButton)
   
        if userDefaults.string(forKey: "uid") != nil {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") {
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelegate.window?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func privacyBtn(_ sender: UIButton) {
        
        if let url = URL(string: "https://github.com/dajyuntsai/Privacy-Policy/blob/master/README.md") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func uesrBtn(_ sender: UIButton) {
        if let url = URL(string: "https://www.eulatemplate.com/live.php?token=cVEFunJ0oBoPd3FsWoKmvEYmNdNgsBbG") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func success() {
        guard let home = storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else { return }
        
        //        self.view.window?.rootViewController = home
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = home
        
        //                self.present(home, animated: true, completion: nil)
    }
    
    @IBAction func guestSignin(_ sender: Any) {
        
        guard let home = storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {
            return }
        
        self.view.window?.rootViewController = home
    }
    
    @IBAction func fbsigninButton(_ sender: UIButton) {
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (_, error) in
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
                
                guard let uid = user?.user.uid,
                    let name = user?.user.displayName,
                    let email = user?.user.email
                    else { return }
                
                let signInID = SignID(
                    name: name,
                    email: email,
                    uid: uid
                    //                    image: image
                )
                
                self.userDefaults.set(name, forKey: "name")
                self.userDefaults.set(email, forKey: "email")
                self.userDefaults.set(uid, forKey: "uid")
                //                self.userDefaults.set(picture, forKey: "image")
                
                do {
                    try self.database.collection("user").document(uid).setData(from: signInID, merge: true)
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
        
    }
    
}

@available(iOS 13.0, *)
extension SinginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            //             Initialize a Firebase credential.
            
            //            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            //            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: currentNonce, accessToken: currentNonce)
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            print("----", idTokenString)
            print("----", nonce)
            
            //            Sign in with Firebase.
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print(self.currentNonce!)
                    
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                guard let uid = user?.user.uid,
                    let email = user?.user.email
                    else { return }
                
//                let name = user?.user.displayName ?? ""
                let givenName = appleIDCredential.fullName?.givenName ?? ""
                let familyName = appleIDCredential.fullName?.familyName ?? ""
                
                let name = givenName + familyName
                
                let signInID = SignID(
                    name: name,
                    email: email,
                    uid: uid
                    //                    image: image
                )
                
                self.userDefaults.set(name, forKey: "name")
                self.userDefaults.set(email, forKey: "email")
                self.userDefaults.set(uid, forKey: "uid")
                //                self.userDefaults.set(picture, forKey: "image")
                
                do {
                    try self.database.collection("user").document(uid).setData(from: signInID, merge: true)
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
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("==========")
        print("Sign in with Apple errored: \(error)")
        print("==========")
    }
    
}
