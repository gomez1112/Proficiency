//
//  AwardTests.swift
//  ProficiencyTests
//
//  Created by Gerard Gomez on 1/7/23.
//

import CoreData
import XCTest
@testable import Proficiency

final class AwardTests: BaseTestCase {
    let awards = Award.allAwards
    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name")
        }
    }
    func testNoAwards() throws {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards.")
        }
    }
    func testIndicatorAwards() throws {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        for (count, value) in values.enumerated() {
            for _ in 0..<value {
                _ = Indicator(context: managedObjectContext)
            }
            let matches = awards.filter { $0.criterion == "indicators" && dataController.hasEarned(award: $0)}
            XCTAssertEqual(matches.count, count + 1, "Adding \(value) indicators should unlock \(count + 1) awards.")
            dataController.deleteAll()
        }
    }
    func testCompletedAwards() throws {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        for (count, value) in values.enumerated() {
            for _ in 0..<value {
                let indicator = Indicator(context: managedObjectContext)
                indicator.completed = true
            }
            let matches = awards.filter { $0.criterion == "complete" && dataController.hasEarned(award: $0)}
            // swiftlint:disable:next line_length
            XCTAssertEqual(matches.count, count + 1, "Completing \(value) indicators should unlock \(count + 1) awards.")
            dataController.deleteAll()
        }
    }
}
