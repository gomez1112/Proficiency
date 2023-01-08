//
//  AwardsView.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/7/23.
//

import SwiftUI

struct AwardsView: View {
    @EnvironmentObject private var dataController: DataController
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false
    static let tag: Tag? = .award
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100))]
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(color(for: award))
                        }
                        .accessibilityLabel(label(for: award))
                        .accessibilityHint(Text(award.description))
                    }
                }
            }
            .navigationTitle("Awards")
        }
        .alert(getAwardAlert(), isPresented: $showingAwardDetails) {}
    message: { Text(selectedAward.description) }
    }
    private func color(for award: Award) -> Color {
        dataController.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5)
    }
    private func label(for award: Award) -> Text {
        Text(dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked")
    }
    private func getAwardAlert() -> LocalizedStringKey {
        dataController.hasEarned(award: selectedAward) ? "Unlocked: \(selectedAward.name)" : "Locked"
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
            .environmentObject(DataController())
    }
}
