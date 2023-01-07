//
//  ContentView.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: Tag?
    var body: some View {
        TabView(selection: $selectedView) {
            Home()
                .tag(Home.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            OutcomesView(showClosedOutcomes: false)
                .tag(OutcomesView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                        Text("Open")
                }
            OutcomesView(showClosedOutcomes: true)
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
