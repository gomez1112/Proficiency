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
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
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
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...4 {
            let unit = Unit(context: viewContext)
            unit.title = "Unit \(i)"
            unit.outcomes = []
            unit.createdAt = Date()
            unit.drivingQuestion = "DQ \(i)"
            unit.theme = "Theme \(i)"
            
            for j in 1...5 {
                let outcome = Outcome(context: viewContext)
                outcome.title = "Outcome \(j)"
                outcome.createdAt = Date()
                outcome.completed = Bool.random()
                outcome.unit = unit
                outcome.indicators = []
                
                for k in 1...3 {
                    let indicator = Indicator(context: viewContext)
                    indicator.title = "Indicator \(k)"
                    indicator.createdAt = Date()
                    indicator.completed = Bool.random()
                    indicator.outcome = outcome
                    indicator.proficiency = Int16.random(in: 1...3)
                }
            }
        }
        
        try viewContext.save()
    }
    
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
