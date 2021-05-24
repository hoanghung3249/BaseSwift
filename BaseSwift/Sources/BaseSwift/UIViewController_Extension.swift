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

// MARK: - Go Back Action
extension UIViewController {
    @objc func goBack() {
        if navigationController != nil { popController() }
        dismissController()
    }
    
    @objc func popController() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissController(completion: (() -> Void)? = nil) {
        view.endEditing(true)
        dismiss(animated: true, completion: completion)
    }
}

// MARK: - ChildViewController
extension UIViewController {
    func addViewController(_ viewController: UIViewController, containerView: UIView, useConstraints: Bool = false) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        if useConstraints {
            viewController.view.scaleEqualSuperView()
        } else {
            viewController.view.frame = containerView.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        viewController.didMove(toParent: self)
    }
    
    func removeViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
