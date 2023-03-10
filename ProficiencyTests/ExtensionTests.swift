//
//  ExtensionTests.swift
//  ProficiencyTests
//
//  Created by Gerard Gomez on 1/14/23.
//

import XCTest
import SwiftUI
@testable import Proficiency

final class ExtensionTests: XCTestCase {
    func testSequenceKeyPathSortingSelf() {
        let indicators = [1, 4, 3, 2, 5]
        let sortedIndicators = indicators.sorted(by: \.self)
        XCTAssertEqual(sortedIndicators, [1, 2, 3, 4, 5], "The sorted numbers must be ascending.")
    }
    func testSequenceKeyPathSortingCustom() {
        struct Example: Equatable {
            let value: String
        }

        let example1 = Example(value: "a")
        let example2 = Example(value: "b")
        let example3 = Example(value: "c")
        let array = [example1, example2, example3]

        let sortedItems = array.sorted(by: \.value) {
            $0 > $1
        }

        XCTAssertEqual(sortedItems, [example3, example2, example1], "Reverse sorting should yield c, b, a.")
    }
    func testBundleDecodingAwards() {
        let awards: [Award] = Bundle.main.load("Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array.")
    }
    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data: String = bundle.load("DecodableString.json")
        // swiftlint:disable:next line_length
        XCTAssertEqual(data, "The rain in Spain falls mainly on the Spaniards.", "The string must match the content of DecodableString.json.")
    }
    func testDecodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data: [String: Int] = bundle.load("DecodableDictionary.json")
        XCTAssertEqual(data.count, 3, "There should be three items decoded from DecodableDictionary.json.")
        XCTAssertEqual(data["One"], 1, "The dictionary should contain Int to String mappings.")
    }
    func testBindingOnChange() {
        // Given
        var onChangeFunctionRun = false

        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }

        var storedValue = ""

        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
        )

        let changedBinding = binding.onChange(exampleFunctionToCall)

        // When
        changedBinding.wrappedValue = "Test"

        // Then
        XCTAssertTrue(onChangeFunctionRun, "The onChange() function was not run.")
    }

}
