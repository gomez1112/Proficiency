//
//  DevelopmentTests.swift
//  ProficiencyTests
//
//  Created by Gerard Gomez on 1/7/23.
//

import CoreData
import XCTest
@testable import Proficiency

final class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()
        XCTAssertEqual(dataController.count(for: Outcome.fetchRequest()), 5, "There should be 5 sample outcomes.")
        XCTAssertEqual(dataController.count(for: Indicator.fetchRequest()), 15, "There should be 15 sample outcomes.")
    }
    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData()
        dataController.deleteAll()
        XCTAssertEqual(dataController.count(for: Outcome.fetchRequest()), 0, "deleteAll() should leave 0 outcomes.")
        XCTAssertEqual(dataController.count(for: Indicator.fetchRequest()), 0, "deleteAll() should leave 0 indicators.")
    }
    func testExampleOutcomeIsClosed() {
        let outcome = Outcome.example
        XCTAssertTrue(outcome.closed, "The example outome should be closed.")
    }
    func testExampleIndicatorIsHighPriority() {
        let indicator = Indicator.example
        XCTAssertEqual(indicator.proficiency, 0, "The example indicator should be high priority.")
    }
}
