//
//  OutcomesView.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct OutcomesView: View {
    let showCompletedOutcomes: Bool
    let outcomes: FetchRequest<Outcome>
    
    init(showCompletedOutcomes: Bool) {
        self.showCompletedOutcomes = showCompletedOutcomes
        outcomes = FetchRequest<Outcome>(entity: Outcome.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Outcome.createdAt, ascending: false)], predicate: NSPredicate(format: "completed = %d", showCompletedOutcomes))
    }
    var body: some View {
        NavigationStack {
            List {
                ForEach(outcomes.wrappedValue) { outcome in
                    Section(header: Text(outcome.title ?? "")) {
                        ForEach(outcome.indicators?.allObjects as? [Indicator] ?? []) { indicator in
                            Text(indicator.title ?? "")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(showCompletedOutcomes ? "Completed" : "Ongoing")
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
