//
//  OutcomeSummary.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/7/23.
//

import SwiftUI

struct OutcomeSummary: View {
    @ObservedObject var outcome: Outcome
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(outcome.outcomeIndicators.count) indicators")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(outcome.outcomeTitle)
                .font(.title2)
            ProgressView(value: outcome.completionAmount)
                .tint(Color(outcome.outcomeColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(outcome.label)
    }
}

struct OutcomeSummary_Previews: PreviewProvider {
    static var previews: some View {
        OutcomeSummary(outcome: .example)
    }
}
