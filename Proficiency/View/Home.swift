//
//  Home.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI
import CoreData

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
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .toolbar {
                Button("Add Data", action: viewModel.addSampleData)
            }
            .navigationTitle("Home")
        }
    }
    private var outcomeRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(dataController: .preview)
    }
}
