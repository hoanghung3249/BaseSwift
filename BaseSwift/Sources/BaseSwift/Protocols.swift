//
//  Protocols.swift
//  BaseSwift
//
//  Created by Hung Nguyen on 24/05/2021.
//

import Foundation

/// Deinit printer is protocol use for print object name when it was deinited
public protocol DeinitLogger {
    /// Print object name when it was deinited
    func logDeinit()
}

extension DeinitLogger {
    public func logDeinit() { print("** Deinit: \(type(of: self)) **") }
}
