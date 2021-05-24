//
//  BaseXibView.swift
//  BaseSwift
//
//  Created by Hung Nguyen on 24/05/2021.
//

import Foundation
#if canImport(UIKit) && os(iOS)
import UIKit

public class BaseXibView: UIView, DeinitLogger {
    deinit {
        logDeinit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        loadViewFromNib()
        setup()
    }
    
    /// Base setup
    func setup() {
        // Override
    }
}
#endif
