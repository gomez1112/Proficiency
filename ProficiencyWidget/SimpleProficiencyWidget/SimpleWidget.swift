//
//  SimpleWidget.swift
//  ProficiencyWidgetExtension
//
//  Created by Gerard Gomez on 1/16/23.
//

import SwiftUI
import WidgetKit

struct ProficiencyWidgetEntryView: View {
    var entry: Provider.Entry
    var body: some View {
        VStack {
            Text("Up next...")
                .font(.title)
            if let indicator = entry.indicators.first {
                Text(indicator.indicatorTitle)
            } else {
                Text("Nothing!")
            }
        }
    }
}

struct SimpleProficiencyWidget: Widget {
    let kind: String = "SimpleProficiencyWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ProficiencyWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Up next...")
        .description("Your #1 top-priority indicator.")
    }
}

struct ProficiencyWidget_Previews: PreviewProvider {
    static var previews: some View {
        ProficiencyWidgetEntryView(entry: SimpleEntry(date: Date(), indicators: [Indicator.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
