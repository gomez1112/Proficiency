//
//  ContentView.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            OutcomesView(showCompletedOutcomes: false)
                .tabItem {
                    Image(systemName: "list.bullet")
                        Text("Ongoing")
                }
            OutcomesView(showCompletedOutcomes: true)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Completed")
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
