//
//  Indicator+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import Foundation

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
    
    static var example: Indicator {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let indicator = Indicator(context: viewContext)
        indicator.title = "Example Indicator"
        indicator.detail = "This is an example indicator."
        indicator.proficiency = 3
        indicator.completed = Bool.random()
        indicator.createdAt = Date()
        return indicator
    }
}
