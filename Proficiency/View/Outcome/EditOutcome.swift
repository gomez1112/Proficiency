//
//  EditOutcome.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct EditOutcome: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataController: DataController
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    let outcome: Outcome
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    init(outcome: Outcome) {
        self.outcome = outcome
        _title = State(wrappedValue: outcome.outcomeTitle)
        _detail = State(wrappedValue: outcome.outcomeDetail)
        _color = State(wrappedValue: outcome.outcomeColor)
    }
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Outcome name", text: $title.onChange(update))
                TextField("Description of this outcome", text: $detail.onChange(update))
            }
            Section(header: Text("Custom outcome color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Outcome.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }
            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a outcome moves it from the Open to Closed tab; deleting it removes the outcome completely.")) {
                Button(outcome.closed ? "Reopen this outcome" : "Close this outcome") {
                    outcome.closed.toggle()
                    update()
                }
                Button("Delete this outcome") {
                    showingDeleteConfirm.toggle()
                }
                .tint(.red)
            }
        }
        .navigationTitle("Edit Outcome")
        .onDisappear(perform: dataController.save)
        .alert("Delete outcome?", isPresented: $showingDeleteConfirm) {
            Button("Delete", role: .destructive, action: delete)
        } message: {
            Text("Are you sure you want to delete this outcome? You will also delete all the indicators it contain.")
        }
    }
    func update() {
        outcome.title = title
        outcome.detail = detail
        outcome.color = color
    }
    func delete() {
        dataController.delete(outcome)
        dismiss()
    }
    func colorButton(for indicator: String) -> some View {
        ZStack {
            Color(indicator)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
            if indicator == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = indicator
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            indicator == color ? [.isButton, .isSelected] : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(indicator))
    }
}

struct EditOutcome_Previews: PreviewProvider {
    static var previews: some View {
        EditOutcome(outcome: .example)
            .environmentObject(DataController())
    }
}
