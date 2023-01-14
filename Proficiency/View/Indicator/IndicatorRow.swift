//
//  IndicatorRow.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import SwiftUI

struct IndicatorRow: View {
    @ObservedObject var indicator: Indicator
    @StateObject private var viewModel: ViewModel
    init(outcome: Outcome, indicator: Indicator) {
        let viewModel = ViewModel(outcome: outcome, indicator: indicator)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.indicator = indicator
    }
    var body: some View {
        NavigationLink(destination: EditIndicator(indicator: indicator)) {
            Label {
                Text(viewModel.title)
            } icon: {
                Image(systemName: viewModel.icon)
                    .foregroundColor(viewModel.color.map { Color($0)} ?? .clear)
            }
        }
        .accessibilityLabel(viewModel.label)
    }
}

struct IndicatorRow_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorRow(outcome: .example, indicator: .example)
    }
}
