//
//  ProcessTracking.swift
//  BaseSwift
//
//  Created by Hung Nguyen on 24/05/2021.
//

import Foundation
#if canImport(UIKit) && os(iOS)
import UIKit

public enum ProcessTrackingType {
    case complete
    case completeWithError
}

/// Simple process tracking will track complete and error, that will add data for any comple process
public class ProcessTracking {
    private var type: ProcessTrackingType
    private var completion: ((Error?) -> Void)?
    private var trackings = [(isCompleted: Bool, data: Any?)]()
    private var error: Error?
    
    init(type: ProcessTrackingType = .completeWithError) {
        self.type = type
    }
    
    /// Create list of tracking process
    /// - Parameters:
    ///   - count: Number of tracker
    ///   - completion: Complete handler after tracking all
    func create(_ count: Int, completion: ((Error?) -> Void)?) {
        trackings = Array(repeating: (false, nil), count: count)
        self.completion = completion
    }
    
    /// Clear request tracking list
    func clearRequestTracking() {
        trackings.removeAll()
        completion = nil
        error = nil
    }
    
    /// Mark tracking completed at index
    /// - Parameters:
    ///   - index: Index of request in list
    ///   - data: Data of this completion
    func completed(at index: Int, data: Any? = nil) {
        guard trackings[safe: index] != nil else { return }
        trackings[index] = (true, data)
        checkProcessTrackingCompleted()
    }
    
    /// Mark tracking eror at index
    /// - Parameters:
    ///   - error: Error occured
    ///   - index: Index of error tracking
    func error(_ error: Error, at index: Int) {
        guard trackings[safe: index] != nil else { return }
        trackings[index] = (true, nil)
        if type == .completeWithError && self.error == nil { self.error = error }
        checkProcessTrackingCompleted()
    }
}

// MARK: - SUPPORT METHODS
extension ProcessTracking {
    /// Checking process has completed tracking or not
    func checkProcessTrackingCompleted() {
        guard !trackings.isEmpty else { return }
        for value in trackings where !value.isCompleted { return }
        completion?(error)
        clearRequestTracking()
    }
    
    //    private func processTrackingError(_ error: Error) {
    //        guard !requestProcessTracking.isEmpty else { return }
    //        completion?(error)
    //        clearRequestTracking()
    //    }
}

// MARK: - SIMPLE PROCESS TRACKING

/// Simple process tracking only track complete and error, that will not add data for any comple process
public class SimpleProcessTracking {
    private var completion: ((Error?) -> Void)?
    private var trackings = Set<Bool>()
    private var error: Error?
    
    func create(_ count: Int, completion: ((Error?) -> Void)?) {
        clearRequestTracking()
        trackings = Set(Array(repeating: false, count: count))
        self.completion = completion
    }
    
    func completed() {
        if !trackings.isEmpty { trackings.removeFirst() }
        checkProcessTrackingCompleted()
    }
    
    func error(_ error: Error) {
        if !trackings.isEmpty { trackings.removeFirst() }
        if self.error == nil { self.error = error }
        checkProcessTrackingCompleted()
    }
}

extension SimpleProcessTracking {
    func clearRequestTracking() {
        completion = nil
        error = nil
        trackings.removeAll()
    }
    
    func checkProcessTrackingCompleted() {
        guard trackings.isEmpty else { return }
        completion?(error)
        clearRequestTracking()
    }
}
#endif
