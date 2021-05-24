//
//  File.swift
//  
//
//  Created by HOANGHUNG on 5/22/21.
//

import Foundation
#if canImport(UIKit) && os(iOS)
import UIKit

public extension UIView {

    func constrainToEdges(_ subview: UIView, insets: UIEdgeInsets = .zero) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: insets.top)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: insets.bottom)
        
        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: insets.left)
        
        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: insets.right)
        
        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint])
    }
    
    func toCicle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    /// Load view from nib and add to owener
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            print("Cannot load view \(String(describing: type(of: self))) from Nib")
            return
        }
        addSubview(view, constraints: .equal)
    }
    
    /// Add subview and set constraints if needed
    /// - Parameters:
    ///   - view: View will add as a subview
    ///   - constraints: Constraints from view to superview
    func addSubview(_ view: UIView, constraints: SubViewContraintType) {
        addSubview(view)
        switch constraints {
        case .equal:
            view.constraintEqualSuperView()
        case let .center(width, height):
            view.constraintToCenterSuperview(width: width, height: height)
        }
    }
    
    /// Insert subview and set constraints if needed
    /// - Parameters:
    ///   - view: View will insert as a subview
    ///   - index: Index of subview in superview
    ///   - constraints: Constraints from view to superview
    func insertSubview(_ view: UIView, at index: Int, constraints: SubViewContraintType) {
        insertSubview(view, at: index)
        switch constraints {
        case .equal:
            view.constraintEqualSuperView()
        case let .center(width, height):
            view.constraintToCenterSuperview(width: width, height: height)
        }
    }
    
    /// Remove all subviews
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func scaleEqualSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                                     trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                                     topAnchor.constraint(equalTo: superView.topAnchor),
                                     bottomAnchor.constraint(equalTo: superView.bottomAnchor)])
    }
    
    /// Constrain layout with another view
    func constrainWith(_ view: UIView, leadingAnchorConstant: CGFloat? = nil, trailingAnchorConstant: CGFloat? = nil, topAnchorConstant: CGFloat? = nil, bottomAnchorConstant: CGFloat? = nil, isCenterXAnchor: Bool = false, isCenterYAnchor: Bool = false, widthConstant: CGFloat? = nil, heightConstant: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        if let leadingAnchorConstant = leadingAnchorConstant {
            constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingAnchorConstant))
        }
        
        if let trailingAnchorConstant = trailingAnchorConstant {
            constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingAnchorConstant))
        }
        
        if let topAnchorConstant = topAnchorConstant {
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant))
        }
        
        if let bottomAnchorConstant = bottomAnchorConstant {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomAnchorConstant))
        }
        
        if let widthConstant = widthConstant {
            constraints.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if let heightConstant = heightConstant {
            constraints.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        if isCenterXAnchor {
            constraints.append(centerXAnchor.constraint(equalTo: view.centerXAnchor))
        }
        
        if isCenterYAnchor {
            constraints.append(centerYAnchor.constraint(equalTo: view.centerYAnchor))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    enum Corner {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    func maskedCorners(_ cornerRadius: CGFloat, corners: [Corner]) {
        self.layer.cornerRadius = cornerRadius
        var maskedCorners = CACornerMask()
        corners.forEach { (corner) in
            switch corner {
            case .topLeft: maskedCorners.insert(.layerMinXMinYCorner)
            case .topRight: maskedCorners.insert(.layerMaxXMinYCorner)
            case .bottomLeft: maskedCorners.insert(.layerMinXMaxYCorner)
            case .bottomRight: maskedCorners.insert(.layerMaxXMaxYCorner)
            }
        }
        self.layer.maskedCorners = maskedCorners
    }
    
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func addBorder(color: UIColor, borderWidth: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
    
}

// MARK: - Constraints
public extension UIView {
    /// Retrieves all constraints that mention the view
    func getAllConstraints() -> [NSLayoutConstraint] {
        // array will contain self and all superviews
        var views = [self]
        
        // get all superviews
        var view = self
        while let superview = view.superview {
            views.append(superview)
            view = superview
        }
        
        // transform views to constraints and filter only those
        // constraints that include the view itself
        return views.flatMap({ $0.constraints }).filter { constraint in
            return constraint.firstItem as? UIView == self ||
                constraint.secondItem as? UIView == self
        }
    }
}
// MARK: - CONSTRAINTS
public extension UIView {
    /// Type of constraints which the subview use for understand the way to add constraints to superview
    enum SubViewContraintType {
        /// Contraints to scale equal to superview
        case equal
        /// Constraint to center of superver with specific width and height of current view
        case center(width: CGFloat? = nil, height: CGFloat? = nil)
    }
    
    /// Contraints equal to super view
    func constraintEqualSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                                     trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                                     topAnchor.constraint(equalTo: superView.topAnchor),
                                     bottomAnchor.constraint(equalTo: superView.bottomAnchor)])
    }
    
    /// Remove all current constraints
    func removeAllConstraint() {
        removeConstraints(constraints)
    }
        
    /// Constraint to center of super view
    /// - Parameters:
    ///   - width: Width of current view
    ///   - height: height of current view
    func constraintToCenterSuperview(width: CGFloat? = nil, height: CGFloat? = nil) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                           centerYAnchor.constraint(equalTo: superview.centerYAnchor)]
        if let width = width, let height = height {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Constrain to another view
    /// - Parameters:
    ///   - view: View will be constraint to
    ///   - leading: Leading constraint constant
    ///   - trailing: Trailing constraint constant
    ///   - top: Top constraint constant
    ///   - bottom: Bottom constraint constant
    ///   - width: Width constraint constant
    ///   - height: Height constraint constant
    ///   - useCenterX: Use center X constraint
    ///   - useCenterY: Use center Y constraint
    func constraint(to view: UIView,
                    leading: CGFloat? = nil, trailing: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil,
                    width: CGFloat? = nil, height: CGFloat? = nil,
                    useCenterX: Bool = false, useCenterY: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if let leading = leading { constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading)) }
        if let trailing = trailing { constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing)) }
        if let top = top { constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: top)) }
        if let bottom = bottom { constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)) }
        if let width = width, !(leading != nil && trailing != nil) { constraints.append(widthAnchor.constraint(equalToConstant: width)) }
        if let height = height, !(top != nil && bottom != nil) { constraints.append(heightAnchor.constraint(equalToConstant: height)) }
        if useCenterX { constraints.append(centerXAnchor.constraint(equalTo: view.centerXAnchor)) }
        if useCenterY { constraints.append(centerYAnchor.constraint(equalTo: view.centerYAnchor)) }
        NSLayoutConstraint.activate(constraints)
    }
}

public extension UIView {
    /// Retrieves all constraints that mention the view
    var allConstraints: [NSLayoutConstraint] {
        // array will contain self and all superviews
        var views = [self]
        
        // get all superviews
        var view = self
        while let superview = view.superview {
            views.append(superview)
            view = superview
        }
        
        // Transform views to constraints and filter only those constraints that include the view itself
        return views.flatMap({ $0.constraints }).filter { constraint in
            constraint.firstItem as? UIView === self || constraint.secondItem as? UIView === self
        }
    }
}

#endif
