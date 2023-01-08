//
//  DataController.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import CoreData
import Foundation

final class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
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
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
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
    private static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd")
        else { fatalError("Failed to locate model file.")}
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url)
        else { fatalError("Failed to load model file.")}
        return managedObjectModel
    }()
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
