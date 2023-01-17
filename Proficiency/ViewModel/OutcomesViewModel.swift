//
//  OutcomesViewModel.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/14/23.
//

import CoreData
import Foundation
import SwiftUI
/**
 Extension to OutcomesView, providing a view model for OutcomesView instances.
 */
extension OutcomesView {
    /**
     The ViewModel class for OutcomesView instances.
     - Observes:
     - sortOrder: The sort order of the outcomes and indicators.
     - outcomes: The list of outcomes associated with this view model.
     - Properties:
     - dataController: The data controller associated with this view model.
     - showClosedOutcomes: A boolean indicating whether closed outcomes should be displayed.
     - outcomesController: A NSFetchedResultsController instance for managing the outcomes.
     */
    final class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        @Published var sortOrder = Indicator.SortOrder.optimized
        @Published var outcomes = [Outcome]()
        @Published var showingUnlockView = false
        let dataController: DataController
        let showClosedOutcomes: Bool
        // A NSFetchedResultsController instance for managing the outcomes.
        private let outcomesController: NSFetchedResultsController<Outcome>
        /**
         Initializes a new view model with the given data controller and showClosedOutcomes.
         - Parameters:
         - dataController: The data controller associated with this view model.
         - showClosedOutcomes: A boolean indicating whether closed outcomes should be displayed.
         */
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
            if !dataController.addOutcome() {
                showingUnlockView.toggle()
            }
        }
        /**
         Add a new indicator to the given outcome.
         - Parameters:
         - outcome: The outcome to add the indicator to.
         */
        func addIndicator(to outcome: Outcome) {
            let indicator = Indicator(context: dataController.container.viewContext)
            indicator.outcome = outcome
            indicator.createdAt = Date()
            indicator.proficiency = 1
            indicator.completed = false
            dataController.save()
        }
        /**
         Deletes the indicators at the given offsets from the given outcome.
         - Parameters:
         - offsets: The offsets of the indicators to be deleted.
         - outcome: The outcome from which the indicators are to be deleted.
         */
        func delete(_ offsets: IndexSet, from outcome: Outcome) {
            let allIndicators = outcome.outcomeIndicators(using: sortOrder)
            for offset in offsets {
                let indicator = allIndicators[offset]
                dataController.delete(indicator)
            }
            dataController.save()
        }
        /**
         Delegate method to handle changes in the outcomes controller.
         - Parameters:
         - controller: The outcomes controller that has changed.
         */
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newOutcomes = controller.fetchedObjects as? [Outcome] {
                outcomes = newOutcomes
            }
        }
    }
}
