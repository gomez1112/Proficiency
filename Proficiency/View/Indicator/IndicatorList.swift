//
//  IndicatorList.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/7/23.
//

import SwiftUI

struct IndicatorList: View {
    let title: LocalizedStringKey
    @Binding var indicators: ArraySlice<Indicator>
    var body: some View {
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
                            .stroke(Color(indicator.outcome?.outcomeColor ?? Color.defaultColor), lineWidth: 3)
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
