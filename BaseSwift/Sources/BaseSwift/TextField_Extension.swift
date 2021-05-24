//
//  File.swift
//  
//
//  Created by HOANGHUNG on 5/22/21.
//

import Foundation
#if canImport(UIKit) && os(iOS)
import UIKit

extension UITextField {
    func setLeftInset(_ value: CGFloat, mode: UITextField.ViewMode = .always) {
        let insetView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        leftView = insetView
        leftViewMode = mode
    }
    
    func setRightInset(_ value: CGFloat, mode: UITextField.ViewMode = .always) {
        let insetView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        rightView = insetView
        rightViewMode = mode
    }
    
    func setLeftRightInset(_ value: CGFloat) {
        setLeftInset(value)
        setRightInset(value)
    }
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }

    func addPadding(_ padding: PaddingSide) {

        self.leftViewMode = .always
        self.layer.masksToBounds = true


        switch padding {

        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always

        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always

        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
    func setUnderLine(_ color: UIColor) {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    enum TextFieldSide {
        case left, right
    }
    
    func setImage(to side: TextFieldSide, image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25)) // set your Own size
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
        iconContainerView.addSubview(iconView)
        switch side {
        case .left:
            leftView = iconContainerView
            leftViewMode = .always
        case .right:
            rightView = iconContainerView
            rightViewMode = .always
        }
        //      leftView = iconContainerView
        //      leftViewMode = .always
        self.tintColor = .lightGray
    }
}
#endif
