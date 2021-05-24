//
//  File.swift
//  
//
//  Created by HOANGHUNG on 5/22/21.
//

import Foundation
#if canImport(UIKit) && os(iOS)
import UIKit

protocol ScreenNearlyHandler: AnyObject {
    /// Index of controller which is nearly with current controller
    ///
    /// - Parameter type: Type of current controller
    /// - Returns: Index of controller nearlly
    func indexOfScreenNearly<T: UIViewController>(_ type: T.Type) -> Int?
    
    /// Check controller which is nearly with current controller is exist or not
    ///
    /// - Parameter type: Type of current controller
    /// - Returns: True is nearly controller has exist
    func screenNearlyContained<T: UIViewController>(_ type: T.Type) -> Bool
    
    /// Get controller which is nearly with current controller
    ///
    /// - Parameter type: Type of current controller
    /// - Returns: Controller which is nearly with current controller
    func screenNearly<T: UIViewController>(_ type: T.Type) -> T?
    
    /// Pop to controller which is nearly with current controller
    ///
    /// - Parameter type: Type of current controller
    func popToNearly<T: UIViewController>(type: T.Type)
}

extension ScreenNearlyHandler where Self: UIViewController {
    func indexOfScreenNearly<T: UIViewController>(_ type: T.Type) -> Int? {
        guard let index = navigationController?.viewControllers.lastIndex(of: self), index > 0 else { return nil }
        
        for screenIndex in (0...index-1).reversed() {
            if let controller = navigationController?.viewControllers[safe: screenIndex], controller.isKind(of: type) {
                return screenIndex
            }
        }
        return nil
    }
    
    func screenNearlyContained<T: UIViewController>(_ type: T.Type) -> Bool {
        guard indexOfScreenNearly(type) != nil else { return false }
        return true
    }
    
    func screenNearly<T: UIViewController>(_ type: T.Type) -> T? {
        guard let index = indexOfScreenNearly(type) else { return nil }
        return navigationController?.viewControllers[safe: index] as? T
    }
    
    func popToNearly<T: UIViewController>(type: T.Type) {
        guard let controller = screenNearly(type) else { return }
        navigationController?.popToViewController(controller, animated: true)
    }
}
#endif
