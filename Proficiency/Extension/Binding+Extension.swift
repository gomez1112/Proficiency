//
//  Binding+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

extension Binding {
    // onChange function takes a handler closure as a parameter
    // The closure takes no parameters and returns nothing
    // The function returns a new Binding instance with a custom setter
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
            handler()
        }

    }
}
