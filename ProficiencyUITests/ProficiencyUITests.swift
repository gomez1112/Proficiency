//
//  ProficiencyUITests.swift
//  ProficiencyUITests
//
//  Created by Gerard Gomez on 1/15/23.
//

import XCTest
import SwiftUI
@testable import Proficiency
final class ProficiencyUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }
    func testApp4TabsVisible() {
        let tabBar = app.tabBars.element
        XCTAssert(tabBar.exists, "Tab bar does not exist")
    }
    func testAppHas4Tabs() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let tabBar = app.tabBars.element
        let tabCount = tabBar.buttons.count
        XCTAssertEqual(tabCount, 4, "There should be 4 tabs in the app.")
    }
}
