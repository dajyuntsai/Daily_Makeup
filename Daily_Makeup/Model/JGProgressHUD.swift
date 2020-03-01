////
////  JGProgressHUD.swift
////  Daily_Makeup
////
////  Created by Hueijyun  on 2020/3/1.
////  Copyright © 2020 Hueijyun . All rights reserved.
////
//
//import Foundation
//
//import JGProgressHUD
//
//enum HUDType {
//
//    case success(String)
//
//    case failure(String)
//}
//
//class LKProgressHUD {
//
//    static let shared = LKProgressHUD()
//
//    private init() { }
//
//    let hud = JGProgressHUD(style: .dark)
//
////    var view: UIView {
////
//////        return AppDelegate.shared.window!.rootViewController!.view
////    }
//
//    static func show(view: UIViewController) {
//
//        switch type {
//
//        case .success(let text):
//
//            showSuccess(text: text)
//
//        case .failure(let text):
//
//            showFailure(text: text)
//        }
//    }
//
//    static func showSuccess(text: String = "success") {
//
//        if !Thread.isMainThread {
//
//            DispatchQueue.main.async {
//                showSuccess(text: text)
//            }
//
//            return
//        }
//
//        shared.hud.textLabel.text = text
//
//        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
//
//        shared.hud.show(in: shared.UIViewController)
//
//        shared.hud.dismiss(afterDelay: 1.5)
//    }
//
//    static func showFailure(text: String = "Failure") {
//
//        if !Thread.isMainThread {
//
//            DispatchQueue.main.async {
//                showFailure(text: text)
//            }
//
//            return
//        }
//
//        shared.hud.textLabel.text = text
//
//        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()
//
//        shared.hud.show(in: shared.UIViewController)
//
//        shared.hud.dismiss(afterDelay: 1.5)
//    }
//
//    static func show() {
//
//        if !Thread.isMainThread {
//
//            DispatchQueue.main.async {
//                show()
//            }
//
//            return
//        }
//
//        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
//
//        shared.hud.textLabel.text = "Loading"
//
//        shared.hud.show(in: shared.UIViewController)
//    }
//
//    static func dismiss() {
//
//        if !Thread.isMainThread {
//
//            DispatchQueue.main.async {
//                dismiss()
//            }
//
//            return
//        }
//
//        shared.hud.dismiss()
//    }
//}
//
