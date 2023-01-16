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
                    outcomesGrid
                    makeIndicatorList(title: "Up next", indicators: viewModel.upNext)
                    makeIndicatorList(title: "More to explore", indicators: viewModel.moreToExplore)
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
    private var outcomesGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: outcomeRows) {
                ForEach(viewModel.outcomes, content: OutcomeSummary.init)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal, .top])
        }
    }
    private func makeIndicatorList(title: LocalizedStringKey, indicators: ArraySlice<Indicator>) -> some View {
        VStack(alignment: .leading) {
            IndicatorList(title: title, indicators: indicators)
        }
        .padding(.horizontal)
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
