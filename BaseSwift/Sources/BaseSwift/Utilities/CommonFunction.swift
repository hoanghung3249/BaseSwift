//
//  File.swift
//  
//
//  Created by HOANGHUNG on 5/22/21.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import Alamofire

struct CommonFunction {

    static func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    static func openAppStore() {
        if let url = URL(string: "[APPSTORE_URL]"), UIApplication.shared.canOpenURL(url) {
            openURL(url)
        }
    }
    
//    static func currentDevice() -> Device {
//        return Device.current
//    }
//
//    static func currentSystemVersion() -> String {
//        return Device.current.systemVersion ?? ""
//    }
    
    static func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func forceDeviceOrientation(_ orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
    }
}

// MARK: - Current ViewController
var currentViewController: UIViewController? {
    if let topController = UIApplication.shared.keyWindow?.rootViewController {
        return topViewController(topController)
    }
    return nil
}

func topViewController(_ viewController: UIViewController) -> UIViewController {
    if let nav = viewController as? UINavigationController {
        return topViewController(nav.visibleViewController!)
    }
    if let tab = viewController as? UITabBarController {
        if let selected = tab.selectedViewController {
            return topViewController(selected)
        }
    }
    if let presented = viewController.presentedViewController {
        return topViewController(presented)
    }
    return viewController
}

// MARK: - Replace screen

func replaceRootViewController(_ controller: UIViewController, animated: Bool = false) {
    guard let window = UIApplication.shared.keyWindow else { fatalError("Cannot find out keyWindow") }
    if !animated {
        window.rootViewController = controller
        return
    }
    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
        let oldState: Bool = UIView.areAnimationsEnabled
        UIView.setAnimationsEnabled(false)
        window.rootViewController = controller
        UIView.setAnimationsEnabled(oldState)
    }, completion: nil)
}
