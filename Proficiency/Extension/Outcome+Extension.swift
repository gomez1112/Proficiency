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
        color ?? "Gold"
    }
    
    var outcomeCreatedAt: Date {
        createdAt ?? Date()
    }
    
    var completionAmount: Double {
        let originalIndicators = indicators?.allObjects as? [Indicator] ?? []
        guard !originalIndicators.isEmpty else { return 0 }
        
        let completedIndicators = originalIndicators.filter(\.completed)
        return Double(completedIndicators.count) / Double(originalIndicators.count)
    }
    
    var outcomeIndicators: [Indicator] {
        indicators?.allObjects as? [Indicator] ?? []
    }
    var outcomeIndicatorsDefaultSorted: [Indicator] {
        
        outcomeIndicators.sorted {
            if $0.completed != $1.completed {
                return !$0.completed
            }
            
            if $0.proficiency != $1.proficiency {
                return $0.proficiency > $1.proficiency
            }
            
            return $0.indicatorCreateAt < $1.indicatorCreateAt
        }
    }
    
    func outcomeIndicators(using sortOrder: Indicator.SortOrder) -> [Indicator] {
        switch sortOrder {
        case .title:
            return outcomeIndicators.sorted(by: \Indicator.indicatorTitle)
        case .createdAt:
            return outcomeIndicators.sorted(by: \Indicator.indicatorCreateAt)
        case .optimized:
            return outcomeIndicatorsDefaultSorted
        }
    }
    
    static var example: Outcome {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let outcome = Outcome(context: viewContext)
        outcome.title = "Example Outcome"
        outcome.detail = "This is an example an outcome."
        outcome.closed = Bool.random()
        outcome.createdAt = Date()
        return outcome
    }
    
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
}
