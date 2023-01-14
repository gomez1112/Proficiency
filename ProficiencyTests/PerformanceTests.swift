//
//  PerformanceTests.swift
//  ProficiencyTests
//
//  Created by Gerard Gomez on 1/14/23.
//

import XCTest
@testable import Proficiency

final class PerformanceTests: BaseTestCase {
//    func testAwardCalculationPerformance() throws {
//           try dataController.createSampleData()
//           let awards = Award.allAwards
//
//           measure {
//               _ = awards.filter(dataController.hasEarned)
//           }
//       }
    func testAwardCalculationPerformance() throws {
        // Create a significant amount of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}
