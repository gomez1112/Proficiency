//
//  ComplexProficiencyWidget.swift
//  ProficiencyWidgetExtension
//
//  Created by Gerard Gomez on 1/16/23.
//

import SwiftUI
import WidgetKit

struct ProficiencyWidgetMultipleEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let entry: Provider.Entry
    var indicators: ArraySlice<Indicator> {
        let indicatorCount: Int
        switch widgetFamily {
        case .systemSmall:
            indicatorCount = 1
        case .systemLarge:
            if dynamicTypeSize < .xxLarge {
                indicatorCount = 5
            } else {
                indicatorCount = 4
            }
        case .accessoryRectangular:
            indicatorCount = 1

        default:
            if dynamicTypeSize < .xLarge {
                indicatorCount = 3
            } else {
                indicatorCount = 2
            }
        }
        return entry.indicators.prefix(indicatorCount)
    }
    var body: some View {
        VStack(spacing: 5) {
            ForEach(indicators) { indicator in
                HStack {
                    Color(indicator.outcome?.color ?? "Light Blue")
                        .frame(width: 5)
                        .clipShape(Capsule())
                    VStack(alignment: .leading) {
                        Text(indicator.indicatorTitle)
                            .font(.headline)
                            .layoutPriority(1)
                        if let outcomeTitle = indicator.outcome?.outcomeTitle {
                            Text(outcomeTitle)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(20)
    }
}

struct ComplexProficiencyWidget: Widget {
    let kind: String = "ComplextProficiencyWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ProficiencyWidgetMultipleEntryView(entry: entry)
        }
        .configurationDisplayName("Up next...")
        .supportedFamilies([.systemSmall, .systemLarge, .accessoryRectangular])
        .description("Your most important indicators.")
    }
}

struct ProficiencyWidgetMultipleEntry_Previews: PreviewProvider {
    static var previews: some View {
        ProficiencyWidgetMultipleEntryView(entry: SimpleEntry(date: Date.now, indicators: [Indicator.example]))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
