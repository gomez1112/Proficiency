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
            .accessibilityLabel(label)
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
    var label: Text {
        if indicator.completed {
            return Text("\(indicator.indicatorTitle), completed")
        } else if indicator.proficiency == 0 {
            return Text("\(indicator.indicatorTitle), high priority.")
        } else {
            return Text(indicator.indicatorTitle)
        }
    }
}

struct IndicatorRow_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorRow(indicator: .example, outcome: .example)
    }
}
