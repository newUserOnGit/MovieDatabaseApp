//
//  GCD+Extensions.swift
//  MovieBase
//
//  Created by Alexander on 05.04.2024.
//

import Foundation

extension DispatchQueue {
    static func mainSyncSafe<T>(_ closure: () -> T) -> T {
        guard !Thread.isMainThread else {
            return closure()
        }
        return DispatchQueue.main.sync(execute: closure)
    }
}
