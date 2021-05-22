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

protocol Reusable {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}

extension UIViewController: Reusable {}

extension UITableView {
    /// Register a UITableViewCell which using a nib file
    ///
    /// - Parameter cell: Type of UITableViewCell class
    func registerNib<T: UITableViewCell>(forCell cell: T.Type) {
        register(UINib(nibName: T.reuseID, bundle: nil), forCellReuseIdentifier: T.reuseID)
    }
    
    /// Register a UITableViewCell which only using a class file
    ///
    /// - Parameter cell: Type of UITableViewCell class
    func registerClass<T: UITableViewCell>(forCell cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseID)
    }
    
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
                                                fatalError()
        }
        return cell
    }
    
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID) as? T else {
                                                fatalError()
        }
        return cell
    }
}

extension UICollectionView {
    /// Register a UICollectionViewCell which using a nib file
    ///
    /// - Parameter cell: Type of UICollectionViewCell class
    func registerNib<T: UICollectionViewCell>(forCell cell: T.Type) {
        register(UINib(nibName: T.reuseID, bundle: nil), forCellWithReuseIdentifier: T.reuseID)
    }
    
    /// Register a UICollectionViewCell which only using a class file
    ///
    /// - Parameter cell: Type of UICollectionViewCell class
    func registerClass<T: UICollectionViewCell>(forCell cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseID)
    }
    
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

extension UINib {
    static func instantiate<T: UIView>(_ type: T.Type) -> UINib {
        return UINib.init(nibName: type.className, bundle: .main)
    }
    
    static func nibView<T: UIView>(_ type: T.Type) -> T {
        let nib = UINib.instantiate(type)
        return nib.instantiate(withOwner: type, options: nil).first as! T
    }
    
}

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}

public extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        var i = self.startIndex
        while i != self.endIndex {
            if i == index {
                return self[index]
            }
            i = self.index(after: i)
        }
        return nil
    }
}

extension URL {
    func params() -> [String:Any] {
        var dict = [String:Any]()

        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            if let queryItems = components.queryItems {
                for item in queryItems {
                    dict[item.name] = item.value!
                }
            }
            return dict
        } else {
            return [:]
        }
    }
}
