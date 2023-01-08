//
//  Sequence+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/7/23.
//

import Foundation

extension Sequence {
    func sorted<Value>(by keyPath: KeyPath<Element, Value>,
                       using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Element] {
        try self.sorted {
            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }

    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        self.sorted(by: keyPath, using: <)
    }
}
