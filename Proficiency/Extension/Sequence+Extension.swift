//
//  Sequence+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/7/23.
//

import Foundation

extension Sequence {
    /**
     Sort the sequence of elements by a specific key path
     - Parameters:
     - keyPath: A key path to an attribute of the element.
     - areInIncreasingOrder: A function that compares two values and returns
     a Bool indicating whether the first value should come before the second value in the sort order.
     - Returns: A new array of elements sorted by the specified key path and comparison function.
     */
    func sorted<Value>(
        by keyPath: KeyPath<Element, Value>,
        using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Element] {
            try self.sorted {
                try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
            }
        }
    /**
     Sort the sequence of elements by a specific key path
     - Parameters:
        - keyPath: A key path to an attribute of the element.
        - Returns: A new array of elements sorted by the specified key path using the default comparison (<)
     */
    func sorted<Value: Comparable>(
        by keyPath: KeyPath<Element, Value>) -> [Element] {
            self.sorted(by: keyPath, using: <)
        }
}
