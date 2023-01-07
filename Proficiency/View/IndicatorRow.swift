//
//  IndicatorRow.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct IndicatorRow: View {
    @ObservedObject var indicator: Indicator
    @ObservedObject var outcome: Outcome
    var body: some View {
        NavigationLink(destination: EditIndicator(indicator: indicator)) {
            Label {
                Text(indicator.indicatorTitle)
            } icon: {
                icon
            }
        }
    }
    
    var icon: some View {
        if indicator.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(outcome.outcomeColor))
        } else if indicator.proficiency == 1 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(outcome.outcomeColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
}

struct IndicatorRow_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorRow(indicator: .example, outcome: .example)
    }
}
