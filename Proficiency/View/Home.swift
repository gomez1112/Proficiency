//
//  Home.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import CoreData
import CoreSpotlight
import SwiftUI

struct Home: View {
    @StateObject private var viewModel: ViewModel
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    static let tag: Tag? = .home
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: outcomeRows) {
                            ForEach(viewModel.outcomes, content: OutcomeSummary.init)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.horizontal, .top])
                    }
                    VStack(alignment: .leading) {
                        IndicatorList(title: "Up nex", indicators: viewModel.upNext)
                        IndicatorList(title: "More to explore", indicators: viewModel.moreToExplore)
                    }
                    .padding(.horizontal)
                }
            }
            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightIndicator)
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .toolbar {
                Button("Add Data", action: viewModel.addSampleData)
            }
            .navigationTitle("Home")
            if let indicator = viewModel.selectedIndicator {
                NavigationLink(destination: EditIndicator(indicator: indicator), label: EmptyView.init)
            }
        }
    }
    private var outcomeRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
    private func loadSpotlightIndicator(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            viewModel.selectedIndicator(with: uniqueIdentifier)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(dataController: .preview)
    }
}
