//
//  PurchaseButton.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/16/23.
//

import SwiftUI

struct PurchaseButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 200, minHeight: 44)
            .background(Color("Light Blue"))
            .clipShape(Capsule())
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

extension ButtonStyle where Self == PurchaseButton {
    static var purchase: Self {
        return .init()
    }
}
