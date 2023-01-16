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
    @State private var remindMe: Bool
    @State private var reminderTime: Date
    @State private var showingNotificationsError = false
    @ObservedObject var outcome: Outcome
    private let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    init(outcome: Outcome) {
        self.outcome = outcome
        _title = State(wrappedValue: outcome.outcomeTitle)
        _detail = State(wrappedValue: outcome.outcomeDetail)
        _color = State(wrappedValue: outcome.outcomeColor)
        if let outcomeReminderTime = outcome.reminderTime {
            _reminderTime = State(wrappedValue: outcomeReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }
    }
    private func toggleClosed() {
        outcome.closed.toggle()
        if outcome.closed {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    var body: some View {
        Form {
            basicSettingsSection
            customColorSection
            reminderSection
            deleteSection
        }
        .navigationTitle("Edit Outcome")
        .onDisappear(perform: dataController.save)
        .alert("Delete outcome?", isPresented: $showingDeleteConfirm) {
            Button("Delete", role: .destructive, action: delete)
        } message: {
            Text("Are you sure you want to delete this outcome? You will also delete all the indicators it contain.")
        }
    }
    private var basicSettingsSection: some View {
        Section(header: Text("Basic settings")) {
            TextField("Outcome name", text: $title.onChange(update))
            TextField("Description of this outcome", text: $detail.onChange(update))
        }
    }
    private var customColorSection: some View {
        Section(header: Text("Custom outcome color")) {
            LazyVGrid(columns: colorColumns) {
                ForEach(Outcome.colors, id: \.self, content: colorButton)
            }
            .padding(.vertical)
        }
    }
    private var reminderSection: some View {
        Section(header: Text("Outcome reminders")) {
            Toggle("Show reminders", isOn: $remindMe.animation().onChange(update))
                .alert("Oops!", isPresented: $showingNotificationsError) {
                } message: {
                    Text("There was a problem. Please check you have notifications enabled.")
                }
            if remindMe {
                DatePicker(
                    "Reminder time",
                    selection: $reminderTime.onChange(update),
                    displayedComponents: .hourAndMinute
                )
            }
        }
    }
    private var deleteSection: some View {
        // swiftlint:disable:next line_length
        Section(footer: Text("Closing a outcome moves it from the Open to Closed tab; deleting it removes the outcome completely.")) {
            Button(outcome.closed ? "Reopen this outcome" : "Close this outcome", action: toggleClosed)
            Button("Delete this outcome") {
                showingDeleteConfirm.toggle()
            }
            .tint(.red)
        }
    }
    private func update() {
        outcome.title = title
        outcome.detail = detail
        outcome.color = color
        if remindMe {
            outcome.reminderTime = reminderTime
            dataController.addReminders(for: outcome) { success in
                if !success {
                    outcome.reminderTime = nil
                    remindMe = false
                    showingNotificationsError = true
                }
            }
        } else {
            outcome.reminderTime = nil
            dataController.removeReminders(for: outcome)
        }
    }
    private func showAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    private func delete() {
        dataController.delete(outcome)
        dismiss()
    }
    private func colorButton(for indicator: String) -> some View {
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
