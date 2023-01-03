//
//  Outcome+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import Foundation

extension Outcome {
    var outcomeTitle: String {
        title ?? "New Outcome"
    }
    var outcomeDetail: String {
        detail ?? ""
    }
    
    var outcomeColor: String {
        color ?? "Light Blue"
    }
    
    var completionAmount: Double {
        guard let originalIndicators = indicators?.allObjects as? [Indicator] else { return 0 }
        guard !originalIndicators.isEmpty else { return 0 }
        
        let completedIndicators = originalIndicators.filter(\.completed)
        return Double(completedIndicators.count) / Double(originalIndicators.count)
    }
    
    var outcomeIndicators: [Indicator] {
        let indicatorsArray = indicators?.allObjects as? [Indicator] ?? []
        
        return indicatorsArray.sorted {
            if $0.completed != $1.completed {
                return !$0.completed
            }
            
            if $0.proficiency != $1.proficiency {
                return $0.proficiency > $1.proficiency
            }
            
            return $0.indicatorCreateAt < $1.indicatorCreateAt
        }
    }
    
    static var example: Outcome {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let outcome = Outcome(context: viewContext)
        outcome.title = "Example Outcome"
        outcome.detail = "This is an example outcome."
        outcome.createdAt = Date()
        return outcome
    }
}
