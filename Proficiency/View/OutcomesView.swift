//
//  OutcomesView.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct OutcomesView: View {
    static let openTag: Tag? = .open
    static let closedTag: Tag? = .closed
    let showClosedOutcomes: Bool
    let outcomes: FetchRequest<Outcome>
    
    init(showCompletedOutcomes: Bool) {
        self.showClosedOutcomes = showCompletedOutcomes
        outcomes = FetchRequest<Outcome>(entity: Outcome.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Outcome.createdAt, ascending: false)], predicate: NSPredicate(format: "closed = %d", showCompletedOutcomes))
    }
    var body: some View {
        NavigationStack {
            List {
                ForEach(outcomes.wrappedValue) { outcome in
                    Section(header: OutcomeHeader(outcome: outcome)) {
                        ForEach(outcome.outcomeIndicators) { indicator in
                            IndicatorRow(indicator: indicator)
                        }
                    }
                }
            }
            .navigationDestination(for: Indicator.self, destination: { indicator in
                EditIndicator(indicator: indicator)
            })
            .listStyle(.insetGrouped)
            .navigationTitle(showClosedOutcomes ? "Closed" : "Open")
        }
    }
}

struct OutcomesView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        OutcomesView(showCompletedOutcomes: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
