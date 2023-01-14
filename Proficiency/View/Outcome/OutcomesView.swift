//
//  OutcomesView.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct OutcomesView: View {
    @StateObject private var viewModel: ViewModel
    @State private var showingsortOrder = false
    static let openTag: Tag? = .open
    static let closedTag: Tag? = .closed
    init(dataController: DataController, showClosedOutcomes: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedOutcomes: showClosedOutcomes)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.outcomes.isEmpty {
                    SelectSomething()
                } else {
                    outcomesList
                }
            }
            .navigationTitle(viewModel.showClosedOutcomes ? "Closed" : "Open")
            .navigationDestination(for: Indicator.self) { indicator in
                EditIndicator(indicator: indicator)
            }
            .toolbar {
                addOutcomeToolbarItem
                sortOrderToolbarItem
            }
            .confirmationDialog("Sort indicators", isPresented: $showingsortOrder) {
                Button("Optimized") { viewModel.sortOrder = .optimized }
                Button("Creation Date") { viewModel.sortOrder = .createdAt }
                Button("Title") { viewModel.sortOrder = .title }
            }
        }
    }
    private var addOutcomeToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if !viewModel.showClosedOutcomes {
                Button {
                    withAnimation {
                        viewModel.addOutcome()
                    }
                } label: {
                    if UIAccessibility.isVoiceOverRunning {
                        Text("Add Outcome")
                    } else {
                        Label("Add New Outcome", systemImage: "plus")
                    }
                }
            }
        }
    }
    private var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingsortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }
    private var outcomesList: some View {
        List {
            ForEach(viewModel.outcomes) { outcome in
                Section(header: OutcomeHeader(outcome: outcome)) {
                    ForEach(outcome.outcomeIndicators(using: viewModel.sortOrder)) { indicator in
                        IndicatorRow(outcome: outcome, indicator: indicator)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: outcome)
                    }
                    if !viewModel.showClosedOutcomes {
                        Button {
                            withAnimation {
                                viewModel.addIndicator(to: outcome)
                            }
                        } label: {
                            Label("Add New Indicator", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct OutcomesView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        OutcomesView(dataController: DataController.preview, showClosedOutcomes: false)
    }
}
