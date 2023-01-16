//
//  ProductVIew.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/16/23.
//

import StoreKit
import SwiftUI

struct ProductVIew: View {
    @EnvironmentObject private var unlockManager: UnlockManager
    let product: SKProduct
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Get Unlimited Outcomes")
                    .font(.headline)
                    .padding(.top, 20)
                Text("You can add three outcomes for free, or pay \(product.localizedPrice) to add unlimited outcomes.")
                Text("If you already bought the unlock on another device, press Restore Purchases.")
                Button("Buy: \(product.localizedPrice)", action: unlock)
                    .buttonStyle(PurchaseButton())
                Button("Restore Purchases", action: unlockManager.restore)
                    .buttonStyle(.purchase)
            }
        }
    }
    func unlock() {
        unlockManager.buy(product: product)
    }
}
