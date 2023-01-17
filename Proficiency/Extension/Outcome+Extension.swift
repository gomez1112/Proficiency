//
//  Outcome+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import CloudKit
import SwiftUI
// Extension for the Outcome model class
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
    // Computed property that returns the completion amount of the outcome as a percentage
    var completionAmount: Double {
        let originalIndicators = indicators?.allObjects as? [Indicator] ?? []
        guard !originalIndicators.isEmpty else { return 0 }
        let completedIndicators = originalIndicators.filter(\.completed)
        return Double(completedIndicators.count) / Double(originalIndicators.count)
    }
    var label: LocalizedStringKey {
        // swiftlint:disable:next line_length
        LocalizedStringKey("\(outcomeTitle), \(outcomeIndicators.count) indicators, \(completionAmount * 100, specifier: "%g")% complete.")
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
    // Method that returns the outcome's indicators sorted using the specified sort order
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
        let controller = DataController.preview
        let viewContext = controller.container.viewContext
        let outcome = Outcome(context: viewContext)
        outcome.title = "Example Outcome"
        outcome.detail = "This is an example an outcome."
        outcome.closed = true
        outcome.createdAt = Date()
        return outcome
    }
    static let colors = [
        "Pink",
        "Purple",
        "Red",
        "Orange",
        "Gold",
        "Green",
        "Teal",
        "Light Blue",
        "Dark Blue",
        "Midnight",
        "Dark Gray",
        "Gray"]
    func prepareCloudRecords() -> [CKRecord] {
        let parentName = objectID.uriRepresentation().absoluteString
        let parentID = CKRecord.ID(recordName: parentName)
        let parent = CKRecord(recordType: "Outcome", recordID: parentID)
        parent["title"] = outcomeTitle
        parent["detail"] = outcomeDetail
        parent["owner"] = "Gerard"
        parent["closed"] = closed
        var records = outcomeIndicatorsDefaultSorted.map { indicator -> CKRecord in
            let childName = indicator.objectID.uriRepresentation().absoluteString
            let childID = CKRecord.ID(recordName: childName)
            let child = CKRecord(recordType: "Indicator", recordID: childID)
            child["title"] = indicator.indicatorTitle
            child["detail"] = indicator.indicatorDetail
            child["completed"] = indicator.completed
            child["outcome"] = CKRecord.Reference(recordID: parentID, action: .deleteSelf)
            return child
        }
        records.append(parent)
        return records
    }
}
