//
//  Binding+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> ()) -> Binding<Value> {
        Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
            handler()
        }

    }
}
