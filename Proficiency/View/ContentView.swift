//
//  ContentView.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import CoreSpotlight
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var dataController: DataController
    @SceneStorage("selectedView") var selectedView: Tag?
    var body: some View {
        TabView(selection: $selectedView) {
            Home(dataController: dataController)
                .tag(Home.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            OutcomesView(dataController: dataController, showClosedOutcomes: false)
                .tag(OutcomesView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                        Text("Open")
                }
            OutcomesView(dataController: dataController, showClosedOutcomes: true)
                .tag(OutcomesView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    Image(systemName: "rosette")
                    Text("Awards")
                }
        }
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
    }
    func moveToHome(_ input: Any) {
        selectedView = Home.tag
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
