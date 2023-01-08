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
}
