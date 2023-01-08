//
//  OutcomesView.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct OutcomesView: View {
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var showingsortOrder = false
    @State private var sortOrder = Indicator.SortOrder.optimized
    static let openTag: Tag? = .open
    static let closedTag: Tag? = .closed
    let showClosedOutcomes: Bool
    let outcomes: FetchRequest<Outcome>
    init(showClosedOutcomes: Bool) {
        self.showClosedOutcomes = showClosedOutcomes
        outcomes = FetchRequest<Outcome>(entity: Outcome.entity(),
                                         sortDescriptors: [NSSortDescriptor(keyPath: \Outcome.createdAt,
                                                                            ascending: false)],
                                         predicate: NSPredicate(format: "closed = %d",
                                                                showClosedOutcomes))
    }
    var body: some View {
        NavigationStack {
            Group {
                if outcomes.wrappedValue.isEmpty {
                    SelectSomething()
                } else {
                    outcomesList
                }
            }
            .navigationTitle(showClosedOutcomes ? "Closed" : "Open")
            .navigationDestination(for: Indicator.self) { indicator in
                EditIndicator(indicator: indicator)
            }
            .toolbar {
                addOutcomeToolbarItem
                sortOrderToolbarItem
            }
            .confirmationDialog("Sort indicators", isPresented: $showingsortOrder) {
                Button("Optimized") { sortOrder = .optimized }
                Button("Creation Date") { sortOrder = .createdAt }
                Button("Title") { sortOrder = .title }
            }
        }
    }
    var addOutcomeToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if !showClosedOutcomes {
                Button(action: addOutcome) {
                    if UIAccessibility.isVoiceOverRunning {
                        Text("Add Outcome")
                    } else {
                        Label("Add New Outcome", systemImage: "plus")
                    }
                }
            }
        }
    }
    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingsortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }
    var outcomesList: some View {
        List {
            ForEach(outcomes.wrappedValue) { outcome in
                Section(header: OutcomeHeader(outcome: outcome)) {
                    ForEach(outcome.outcomeIndicators(using: sortOrder)) { indicator in
                        IndicatorRow(indicator: indicator, outcome: outcome)
                    }
                    .onDelete { offsets in
                        delete(offsets, from: outcome)
                    }
                    if !showClosedOutcomes {
                        Button {
                            addIndicator(to: outcome)
                        } label: {
                            Label("Add New Indicator", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    func addOutcome() {
        withAnimation {
            let outcome = Outcome(context: managedObjectContext)
            outcome.closed = false
            outcome.createdAt = Date()
            dataController.save()
        }
    }
    func addIndicator(to outcome: Outcome) {
        withAnimation {
            let indicator = Indicator(context: managedObjectContext)
            indicator.outcome = outcome
            indicator.createdAt = Date()
            dataController.save()
        }
    }
    func delete(_ offsets: IndexSet, from outcome: Outcome) {
        let allIndicators = outcome.outcomeIndicators(using: sortOrder)
        for offset in offsets {
            let indicator = allIndicators[offset]
            dataController.delete(indicator)
        }
        dataController.save()
    }
}

struct OutcomesView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        OutcomesView(showClosedOutcomes: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
