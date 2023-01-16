//
//  SKProduct+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/16/23.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
