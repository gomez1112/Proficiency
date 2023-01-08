//
//  AssetTests.swift
//  ProficiencyTests
//
//  Created by Gerard Gomez on 1/7/23.
//

import XCTest
@testable import Proficiency

final class AssetTests: XCTestCase {
    func testColorExist() {
        for color in Outcome.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }
    func testJSONLoadsCorrectly() {
        XCTAssertTrue(!Award.allAwards.isEmpty, "Failed to load awards from JSON.")
    }
}
