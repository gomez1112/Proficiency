//
//  Indicator+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import Foundation

// Extension for the Indicator model class
extension Indicator {
    var indicatorTitle: String {
        title ?? "New Indicator"
    }
    var indicatorDetail: String {
        detail ?? ""
    }
    var indicatorCreateAt: Date {
        createdAt ?? Date()
    }
    enum SortOrder {
        case optimized, title, createdAt
    }
    static var example: Indicator {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext
        let indicator = Indicator(context: viewContext)
        indicator.title = "Example Indicator"
        indicator.detail = "This is an example indicator."
        indicator.proficiency = 0
        indicator.completed = false
        indicator.createdAt = Date()
        return indicator
    }
}
