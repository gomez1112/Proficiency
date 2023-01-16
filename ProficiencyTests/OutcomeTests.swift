//
//  OutcomeTests.swift
//  ProficiencyTests
//
//  Created by Gerard Gomez on 1/7/23.
//

import CoreData
import XCTest
@testable import Proficiency

final class OutcomeTests: BaseTestCase {
    let indicator = Indicator.example
    let outcome = Outcome.example
    func testCreatingOutcomesAndIndicators() {
        let targetCount = 10
        for _ in 0..<targetCount {
            let outcome = Outcome(context: managedObjectContext)
            for _ in 0..<targetCount {
                let indicator = Indicator(context: managedObjectContext)
                indicator.outcome = outcome
            }
        }
        XCTAssertEqual(dataController.count(for: Outcome.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Indicator.fetchRequest()), targetCount * targetCount)
    }
    func testDeletingOutcomeCascadeDeletesIndicators() throws {
        try dataController.createSampleData()
        let request = NSFetchRequest<Outcome>(entityName: "Outcome")
        let outcomes = try managedObjectContext.fetch(request)
        dataController.delete(outcomes[0])
        XCTAssertEqual(dataController.count(for: Outcome.fetchRequest()), 4)
        XCTAssertEqual(dataController.count(for: Indicator.fetchRequest()), 12)
    }
    func testCompletionAmount() {
        let outcome = Outcome.example
        // Test empty indicators
        XCTAssertEqual(outcome.completionAmount, 0)
        // Test all indicators completed
        let indicators = (0...5).map { _ in
            let indicator = Indicator.example
            indicator.completed = true
            return indicator
        }
        outcome.indicators = NSSet(array: indicators)
        XCTAssertEqual(outcome.completionAmount, 1)
        // Test half indicators completed
        indicators[0].completed = false
        XCTAssertEqual(outcome.completionAmount, 5 / 6)
    }
    func testOutcomeIndicatorsDefaultSorted_emptyIndicators() {
        let outcome = Outcome.example
        XCTAssertEqual(outcome.outcomeIndicatorsDefaultSorted, [])
    }
    func testColors() {
        // Assert that the colors array contains the expected elements
        XCTAssertEqual(Outcome.colors, [
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
            "Gray"
        ])
        // Assert that the colors array have 12 elements
        XCTAssertEqual(Outcome.colors.count, 12)
        // Assert that the colors array is not empty
        XCTAssertFalse(Outcome.colors.isEmpty)
    }
    func testDeleteAll() {
        // Create some mock Outcome, and Indicator objects and insert them into the context
        _ = Outcome(context: dataController.container.viewContext)
        _ = Outcome(context: dataController.container.viewContext)
        _ = Indicator(context: dataController.container.viewContext)
        _ = Indicator(context: dataController.container.viewContext)
        try? dataController.container.viewContext.save()
        // Call the deleteAll function
        dataController.deleteAll()
        let outcomes = try? dataController.container.viewContext.fetch(Outcome.fetchRequest())
        XCTAssertEqual(outcomes?.count, 0)
        let indicators = try? dataController.container.viewContext.fetch(Indicator.fetchRequest())
        XCTAssertEqual(indicators?.count, 0)
    }
}
