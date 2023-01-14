//
//  EditIndicator.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct EditIndicator: View {
    @EnvironmentObject private var dataController: DataController
    @State private var title: String
    @State private var detail: String
    @State private var proficiency: Int
    @State private var completed: Bool
    let indicator: Indicator
    init(indicator: Indicator) {
        self.indicator = indicator
        title = indicator.indicatorTitle
        detail = indicator.indicatorDetail
        proficiency = Int(indicator.proficiency)
        completed = indicator.completed
    }
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Indicator name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }
            Section(header: Text("Proficiency")) {
                Picker("Proficiency", selection: $proficiency.onChange(update)) {
                    Text("NY").tag(1)
                    Text("P").tag(2)
                    Text("HP").tag(3)
                }
                .pickerStyle(.segmented)
            }
            Section {
                Toggle("Mark Completed", isOn: $completed.onChange(update))
            }
        }
        .navigationTitle("Edit Indicator")
        .onDisappear(perform: dataController.save)
    }
    private func update() {
        indicator.outcome?.objectWillChange.send()
        indicator.title = title
        indicator.detail = detail
        indicator.proficiency = Int16(proficiency)
        indicator.completed = completed
    }
}

struct EditIndicator_Previews: PreviewProvider {
    static var previews: some View {
        EditIndicator(indicator: .example)
            .environmentObject(DataController())
    }
}
