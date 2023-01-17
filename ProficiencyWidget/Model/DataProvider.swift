//
//  DataProvider.swift
//  ProficiencyWidgetExtension
//
//  Created by Gerard Gomez on 1/16/23.
//

import WidgetKit

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry
    func loadIndicators() -> [Indicator] {
        let dataController = DataController()
        let indicatorRequest = dataController.fetchRequestForTopIndicators(count: 5)
        return dataController.results(for: indicatorRequest)
    }
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), indicators: [Indicator.example])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), indicators: loadIndicators())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date.now, indicators: loadIndicators())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}
struct SimpleEntry: TimelineEntry {
    let date: Date
    let indicators: [Indicator]
}
