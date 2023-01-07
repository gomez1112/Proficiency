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
            VStack(alignment: .leading) {
                Gauge(value: outcome.completionAmount) {
                    Text(outcome.outcomeTitle)
                }
                .gaugeStyle(.accessoryLinearCapacity)
                .tint(Color(outcome.outcomeColor))
            }
            Spacer()
            NavigationLink(value: outcome) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 10)
        .navigationDestination(for: Outcome.self) { outcome in
            EditOutcome(outcome: outcome)
        }
    }
}

struct OutcomeHeader_Previews: PreviewProvider {
    static var previews: some View {
        OutcomeHeader(outcome: .example)
    }
}
