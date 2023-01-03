//
//  IndicatorRow.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct IndicatorRow: View {
    @ObservedObject var indicator: Indicator
    var body: some View {
        NavigationLink(value: indicator) {
            Text(indicator.indicatorTitle)
        }
    }
}

struct IndicatorRow_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorRow(indicator: Indicator.example)
    }
}
