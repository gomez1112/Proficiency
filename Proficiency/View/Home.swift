//
//  Home.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI
import CoreData

struct Home: View {
    @EnvironmentObject private var dataController: DataController
    @FetchRequest(entity: Outcome.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Outcome.title,
                                                     ascending: true)],
                  predicate: NSPredicate(format: "closed = false"))
    var outcomes: FetchedResults<Outcome>
    let indicators: FetchRequest<Indicator>
    static let tag: Tag? = .home
    init() {
        let request: NSFetchRequest<Indicator> = Indicator.fetchRequest()
        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "outcome.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        request.predicate = compoundPredicate
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Indicator.proficiency, ascending: false)
        ]
        request.fetchLimit = 10
        indicators = FetchRequest(fetchRequest: request)
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: outcomeRows) {
                            ForEach(outcomes, content: OutcomeSummary.init)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.horizontal, .top])
                    }
                    VStack(alignment: .leading) {
                        IndicatorList(title: "Up nex", indicators: indicators.wrappedValue.prefix(3))
                        IndicatorList(title: "More to explore", indicators: indicators.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .toolbar {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
    var outcomeRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(DataController())
    }
}
