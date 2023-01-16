//
//  ContentView.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import CoreSpotlight
import SwiftUI

struct ContentView: View {
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject private var dataController: DataController
    @SceneStorage("selectedView") var selectedView: Tag?
    private let newOutcomeActivity = "com.transfinite.newOutcome"
    var body: some View {
        TabView(selection: $selectedView) {
            makeTabView(title: "Home",
                        tag: Home.tag,
                        icon: "house",
                        view: Home(dataController: dataController)
            )
            makeTabView(title: "Open",
                        tag: OutcomesView.openTag,
                        icon: "list.bullet",
                        view: OutcomesView(dataController: dataController, showClosedOutcomes: false)
            )
            makeTabView(title: "Closed",
                        tag: OutcomesView.closedTag,
                        icon: "checkmark",
                        view: OutcomesView(dataController: dataController, showClosedOutcomes: true)
            )
            makeTabView(title: "Awards",
                        tag: AwardsView.tag,
                        icon: "rosette",
                        view: AwardsView())
        }
        .onAppear {
            guard dataController.count(for: Outcome.fetchRequest()) >= 5 else { return }
            requestReview()
        }
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
        .onContinueUserActivity(newOutcomeActivity, perform: createOutcome)
        .userActivity(newOutcomeActivity) { activity in
            activity.isEligibleForPrediction = true
            activity.title = "New Outcome"
        }
    }
    func createOutcome(_ userActivity: NSUserActivity) {
        selectedView = OutcomesView.openTag
        dataController.addOutcome()
    }
    func moveToHome(_ input: Any) {
        selectedView = Home.tag
    }
    private func makeTabView(title: String, tag: Tag?, icon: String, view: some View) -> some View {
        view
            .tag(tag)
            .tabItem {
                Image(systemName: icon)
                Text(title)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let dataController = DataController.preview
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
