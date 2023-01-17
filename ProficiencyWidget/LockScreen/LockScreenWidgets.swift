//
//  LockScreenWidgets.swift
//  ProficiencyWidgetExtension
//
//  Created by Gerard Gomez on 1/16/23.
//

import SwiftUI
import WidgetKit

struct ProficiencyLockScreenEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    var body: some View {
        switch widgetFamily {
        case .accessoryRectangular:
            ZStack {
                AccessoryWidgetBackground()
                VStack {
                    Text("Highest Priority")
                        .font(.caption)
                    Text("\(entry.indicators.count)")
                }
            }
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack {
                    Text("Highest Priority")
                        .font(.caption)
                    Text("\(entry.indicators.count)")
                }
            }
        case .accessoryInline:
            ZStack {
                AccessoryWidgetBackground()
                VStack {
                    Text("\(entry.indicators.count)")
                }
            }
        case .systemSmall:
            EmptyView()
        case .systemMedium:
            EmptyView()
        case .systemLarge:
            EmptyView()
        case .systemExtraLarge:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct ProficiencyLockScreenWidget: Widget {
    let kind: String = "ProficiencyLockScreenWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ProficiencyLockScreenEntryView(entry: entry)
        }
        .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular])
        .configurationDisplayName("Indicator Remaining")
        .description("Incomplete indicator ")
    }
}

struct ProficiencyLockScreenEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ProficiencyLockScreenEntryView(entry: SimpleEntry(date: Date(), indicators: [Indicator.example]))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
