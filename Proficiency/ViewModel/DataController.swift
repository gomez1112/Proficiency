//
//  DataController.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import CoreData
import CoreSpotlight
import Foundation
import UserNotifications

/// A `DataController` class is responsible for managing the Core Data stack of the app.
final class DataController: ObservableObject {
    /// The `NSPersistentCloudKitContainer` object that manages the Core Data stack.
    let container: NSPersistentCloudKitContainer
    let defaults: UserDefaults
    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }
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
        }
        // Load the persistent stores and check for any errors. If there is an error, log a fatal error.
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    /// Saves the changes in the view context of the `NSPersistentCloudKitContainer` object.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
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
    /// Deletes all `Unit`, `Outcome`, and `Indicator`
    /// objects from the view context of the `NSPersistentCloudKitContainer` object.
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Unit.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Outcome.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
        let fetchRequest3: NSFetchRequest<NSFetchRequestResult> = Indicator.fetchRequest()
        let batchDeleteRequest3 = NSBatchDeleteRequest(fetchRequest: fetchRequest3)
        _ = try? container.viewContext.execute(batchDeleteRequest3)
    }
    /// Returns the count of the objects for a given `NSFetchRequest` object.
    /// - Parameter fetchRequest: The `NSFetchRequest` object whose count is to be returned.
    /// - Returns: The count of the objects for the given NSFetchRequest object.
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    /// Returns a boolean value indicating if the user has earned the given award.
    /// - Parameters:
    ///   - award: The `Award` object to be checked.
    /// - Returns: A boolean value indicating if the user has earned the given award.
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "indicators":
            let fetchRequest: NSFetchRequest<Indicator> = NSFetchRequest(entityName: "Indicator")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "complete":
            let fetchRequest: NSFetchRequest<Indicator> = NSFetchRequest(entityName: "Indicator")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        default:
            return false
        }
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
    func addReminders(for outcome: Outcome, completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotifications { success in
                    if success {
                        self.placeReminders(for: outcome, completion: completion)
                    } else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
            case .authorized:
                self.placeReminders(for: outcome, completion: completion)
            default:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    func removeReminders(for outcome: Outcome) {
        let center = UNUserNotificationCenter.current()
        let id = outcome.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    private func requestNotifications(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }
    private func placeReminders(for outcome: Outcome, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = outcome.outcomeTitle
        if let outcomeDetail = outcome.detail {
            content.subtitle = outcomeDetail
        }
        let components = Calendar.current.dateComponents([.hour, .minute], from: outcome.reminderTime ?? Date.now)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let id = outcome.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    // Spotlight
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
