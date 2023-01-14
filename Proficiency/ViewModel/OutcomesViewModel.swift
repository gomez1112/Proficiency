//
//  OutcomesViewModel.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/14/23.
//

import CoreData
import Foundation
import SwiftUI

extension OutcomesView {
    final class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        @Published var sortOrder = Indicator.SortOrder.optimized
        @Published var outcomes = [Outcome]()
        let dataController: DataController
        let showClosedOutcomes: Bool
        private let outcomesController: NSFetchedResultsController<Outcome>
        init(dataController: DataController, showClosedOutcomes: Bool) {
            self.dataController = dataController
            self.showClosedOutcomes = showClosedOutcomes
            let request: NSFetchRequest<Outcome> = Outcome.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Outcome.createdAt, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedOutcomes)
            outcomesController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            super.init()
            outcomesController.delegate = self
            do {
                try outcomesController.performFetch()
                outcomes = outcomesController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch outcomes")
            }
        }
        func addOutcome() {
            let outcome = Outcome(context: dataController.container.viewContext)
            outcome.closed = false
            outcome.createdAt = Date()
            dataController.save()
        }
        func addIndicator(to outcome: Outcome) {
            let indicator = Indicator(context: dataController.container.viewContext)
            indicator.outcome = outcome
            indicator.createdAt = Date()
            dataController.save()
        }
        func delete(_ offsets: IndexSet, from outcome: Outcome) {
            let allIndicators = outcome.outcomeIndicators(using: sortOrder)
            for offset in offsets {
                let indicator = allIndicators[offset]
                dataController.delete(indicator)
            }
            dataController.save()
        }
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newOutcomes = controller.fetchedObjects as? [Outcome] {
                outcomes = newOutcomes
            }
        }
    }
}
