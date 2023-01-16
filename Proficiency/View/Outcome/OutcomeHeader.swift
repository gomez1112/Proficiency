//
//  OutcomeHeader.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct OutcomeHeader: View {
    @ObservedObject var outcome: Outcome
    var body: some View {
        HStack {
            completionAmountSection
            Spacer()
            editButton
        }
        .accessibilityElement(children: .ignore)
        .padding(.bottom, 10)
        .navigationDestination(for: Outcome.self) { outcome in
            EditOutcome(outcome: outcome)
        }
    }
    private var completionAmountSection: some View {
        VStack(alignment: .leading) {
            Gauge(value: outcome.completionAmount) {
                Text(outcome.outcomeTitle)
            }
            .gaugeStyle(.accessoryLinearCapacity)
            .tint(Color(outcome.outcomeColor))
        }
    }
    private var editButton: some View {
        NavigationLink(value: outcome) {
            Image(systemName: "square.and.pencil")
                .imageScale(.large)
        }
    }
}

struct OutcomeHeader_Previews: PreviewProvider {
    static var previews: some View {
        OutcomeHeader(outcome: .example)
    }
}
