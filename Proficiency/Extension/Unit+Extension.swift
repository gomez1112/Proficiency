//
//  Unit+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import Foundation

extension Unit {
    var unitTitle: String {
        title ?? "New Unit"
    }
    var unitDetail: String {
        detail ?? ""
    }
    var unitCreatedAt: Date {
        createdAt ?? Date()
    }
    var unitTheme: String {
        theme ?? ""
    }
    var unitDrivingQuestion: String {
        drivingQuestion ?? ""
    }
    var unitOutcomes: [Outcome] {
        (outcomes?.allObjects as? [Outcome] ?? []).sorted {
            return $0.outcomeCreatedAt > $1.outcomeCreatedAt
        }
    }
    static var example: Unit {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext
        let unit = Unit(context: viewContext)
        unit.title = "Example Unit"
        unit.detail = "This is an example an unit."
        unit.createdAt = Date()
        unit.theme = "This is an theme."
        unit.drivingQuestion = "Is this a driving question?"
        return unit
    }
}
