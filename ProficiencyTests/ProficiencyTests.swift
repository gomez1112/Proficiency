//
//  ProficiencyTests.swift
//  ProficiencyTests
//
//  Created by Gerard Gomez on 1/7/23.
//

import CoreData
import XCTest
@testable import Proficiency
class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
