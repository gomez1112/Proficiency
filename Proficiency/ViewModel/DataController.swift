//
//  DataController.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import CoreData
import CoreSpotlight
import Foundation
import WidgetKit

/// A `DataController` class is responsible for managing the Core Data stack of the app.
final class DataController: ObservableObject {
    /// The `NSPersistentCloudKitContainer` object that manages the Core Data stack.
    let container: NSPersistentCloudKitContainer
    let defaults: UserDefaults
    /**
     A computed property that allows easy access to the full version unlock status stored in UserDefaults.
     - Note: Setting the value to true will unlock the full version of the app, while setting it to false will lock it.
     */
    var fullVersionUnlocked: Bool {
        /**
         Retrieves the full version unlock status from UserDefaults
         - Returns: a Bool indicating the status of the full version unlock
         */
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }
        /**
         Sets the full version unlock status in UserDefaults
         - Parameter newValue: a Bool indicating the new status of the full version unlock
         */
        set {
            defaults.set(newValue, forKey: "fullVersionUnlocked")
        }
    }
    /// Initializes a `DataController` object with an optional flag to indicate
    /// if the persistent store should be in-memory.
    /// - Parameter inMemory: A boolean value indicating if the persistent store should be in-memory.
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        // If inMemory flag is set to true, set the URL of the persistent store description
        // to "/dev/null" to create an in-memory store.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let groupID = "group.com.transfinite.proficiency"
            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Main.sqlite")
            }
        }
        // Load the persistent stores and check for any errors. If there is an error, log a fatal error.
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
            self.container.viewContext.automaticallyMergesChangesFromParent = true
            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
            }
            #endif
        }
    }
    /**
     Add a new outcome to the data controller.
     */
    @discardableResult
    func addOutcome() -> Bool {
        let canCreate = fullVersionUnlocked || count(for: Outcome.fetchRequest()) < 3
        if canCreate {
            let outcome = Outcome(context: container.viewContext)
            outcome.closed = false
            outcome.createdAt = Date()
            save()
            return true
        } else {
            return false
        }
    }
    /// Saves the changes in the view context of the `NSPersistentCloudKitContainer` object.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    /// Deletes a given `NSManagedObject` from the view context of the `NSPersistentCloudKitContainer` object.
    /// - Parameter object: The `NSManagedObject` to be deleted.
    func delete(_ object: NSManagedObject) {
        let id = object.objectID.uriRepresentation().absoluteString
        if object is Indicator {
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
        } else {
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
        }
        container.viewContext.delete(object)
    }
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest1.resultType = .resultTypeObjectIDs
        if let delete = try? container.viewContext.execute(batchDeleteRequest1) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    /// Deletes all `Unit`, `Outcome`, and `Indicator`
    /// objects from the view context of the `NSPersistentCloudKitContainer` object.
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Unit.fetchRequest()
        delete(fetchRequest1)
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Outcome.fetchRequest()
        delete(fetchRequest2)
        let fetchRequest3: NSFetchRequest<NSFetchRequestResult> = Indicator.fetchRequest()
        delete(fetchRequest3)
    }
    /// Returns the count of the objects for a given `NSFetchRequest` object.
    /// - Parameter fetchRequest: The `NSFetchRequest` object whose count is to be returned.
    /// - Returns: The count of the objects for the given NSFetchRequest object.
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    /// Creates sample data for the app.
    /// - Throws: An error if there is a problem creating the sample data.
    func createSampleData() throws {
        let viewContext = container.viewContext
        for unitCounter in 1...1 {
            let unit = Unit(context: viewContext)
            unit.title = "Unit \(unitCounter)"
            unit.outcomes = []
            unit.createdAt = Date()
            unit.drivingQuestion = "DQ \(unitCounter)"
            unit.theme = "Theme \(unitCounter)"
            for outcomeCounter in 1...5 {
                let outcome = Outcome(context: viewContext)
                outcome.title = "Outcome \(outcomeCounter)"
                outcome.createdAt = Date()
                outcome.closed = true
                outcome.unit = unit
                outcome.indicators = []
                for indicatorCounter in 1...3 {
                    let indicator = Indicator(context: viewContext)
                    indicator.title = "Indicator \(indicatorCounter)"
                    indicator.createdAt = Date()
                    indicator.completed = Bool.random()
                    indicator.outcome = outcome
                    indicator.proficiency = Int16.random(in: 1...3)
                }
            }
        }
        try viewContext.save()
    }
    /// Update the given indicator in the search index.
    /// - Parameters:
    ///    - indicator: The indicator to update in the search index.
    func update(_ indicator: Indicator) {
        let indicatorID = indicator.objectID.uriRepresentation().absoluteString
        let outcomeID = indicator.outcome?.objectID.uriRepresentation().absoluteString
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = indicator.title
        attributeSet.contentDescription = indicator.detail
        let searchableIndicator = CSSearchableItem(
            uniqueIdentifier: indicatorID,
            domainIdentifier: outcomeID,
            attributeSet: attributeSet
        )
        CSSearchableIndex.default().indexSearchableItems([searchableIndicator])
        save()
    }
    func fetchRequestForTopIndicators(count: Int) -> NSFetchRequest<Indicator> {
        // Construct a fetch request to show the 10 highest-priority,
        // incomplete items from open projects.
        let indicatorRequest: NSFetchRequest<Indicator> = Indicator.fetchRequest()
        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "outcome.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        indicatorRequest.predicate = compoundPredicate
        indicatorRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Indicator.proficiency, ascending: false)]
        indicatorRequest.fetchLimit = count
        return indicatorRequest
    }
    func fetchRequestForIndicators() -> NSFetchRequest<Indicator> {
        // Construct a fetch request to show the 10 highest-priority,
        // incomplete items from open projects.
        let indicatorRequest: NSFetchRequest<Indicator> = Indicator.fetchRequest()
        let openPredicate = NSPredicate(format: "outcome.closed = false")
        indicatorRequest.predicate = openPredicate
        indicatorRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Indicator.proficiency, ascending: false)]
        return indicatorRequest
    }
    func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
        (try? container.viewContext.fetch(fetchRequest)) ?? []
    }
    /**
     Retrieve an indicator with the given unique identifier from the search index.
     - Parameters:
     - uniqueIdentifier: A string representing the unique identifier of the indicator to retrieve.
     - Returns:
     An optional Indicator that matches the given unique identifier.
     */
    func indicator(with uniqueIdentifier: String) -> Indicator? {
        guard let url = URL(string: uniqueIdentifier) else { return nil }
        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        return try? container.viewContext.existingObject(with: id) as? Indicator
    }
    // Declare a private static constant 'model' of type NSManagedObjectModel
    private static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd")
        else { fatalError("Failed to locate model file.")}
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url)
        else { fatalError("Failed to load model file.")}
        return managedObjectModel
    }()
    // Declare a static variable 'preview' of type DataController
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        return dataController
    }()
}
