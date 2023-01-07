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
    @FetchRequest(entity: Outcome.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Outcome.title, ascending: true)], predicate: NSPredicate(format: "closed = false")) var outcomes: FetchedResults<Outcome>
    let indicators: FetchRequest<Indicator>
    static let tag: Tag? = .home
    
    init() {
        let request: NSFetchRequest<Indicator> = Indicator.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")
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
                            ForEach(outcomes) { outcome in
                                VStack(alignment: .leading) {
                                    Text("\(outcome.outcomeIndicators.count) indicators")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(outcome.outcomeTitle)
                                        .font(.title2)
                                    ProgressView(value: outcome.completionAmount)
                                        .tint(Color(outcome.outcomeColor))
                                }
                                .padding()
                                .background(Color.secondarySystemGroupedBackground)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5)
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.horizontal, .top])
                    }
                    VStack(alignment: .leading) {
                        list("Up next", for: indicators.wrappedValue.prefix(3))
                        list("More to explore", for: indicators.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
    
    var outcomeRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
    
    @ViewBuilder
    func list(_ title: String, for indicators: FetchedResults<Indicator>.SubSequence) -> some View {
        if indicators.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            
            ForEach(indicators) { indicator in
                NavigationLink(destination: EditIndicator(indicator: indicator)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(indicator.outcome?.outcomeColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 44, height: 44)
                        VStack(alignment: .leading) {
                            Text(indicator.indicatorTitle)
                                .font(.title2)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if !indicator.indicatorDetail.isEmpty {
                                Text(indicator.indicatorDetail)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(DataController())
    }
}
