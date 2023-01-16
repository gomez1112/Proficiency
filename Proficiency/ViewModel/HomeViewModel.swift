//
//  HomeViewModel.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/14/23.
//

import CoreData
import Foundation

extension Home {
    final class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let outcomesController: NSFetchedResultsController<Outcome>
        private let indicatorsController: NSFetchedResultsController<Indicator>
        @Published var outcomes = [Outcome]()
        @Published var indicators = [Indicator]()
        @Published var selectedIndicator: Indicator?
        let dataController: DataController
        var upNext: ArraySlice<Indicator> {
            indicators.prefix(3)
        }
        var moreToExplore: ArraySlice<Indicator> {
            indicators.dropFirst(3)
        }
        /**
         Initialize a new view model with the given data controller.
         - Parameters:
         - dataController: The data controller to be used by this view model.
         */
        init(dataController: DataController) {
            self.dataController = dataController
            // Construct a fetch request to show all open projects.
            let outcomeRequest: NSFetchRequest<Outcome> = Outcome.fetchRequest()
            outcomeRequest.predicate = NSPredicate(format: "closed = false")
            outcomeRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Outcome.title, ascending: true)]
            outcomesController = NSFetchedResultsController(
                fetchRequest: outcomeRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            // Construct a fetch request to show the 10 highest-priority,
            // incomplete items from open projects.
            let indicatorRequest: NSFetchRequest<Indicator> = Indicator.fetchRequest()
            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "outcome.closed = false")
            indicatorRequest.predicate = NSCompoundPredicate(type: .and,
                                                             subpredicates: [completedPredicate, openPredicate])
            indicatorRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Indicator.proficiency, ascending: false)]
            indicatorRequest.fetchLimit = 10
            indicatorsController = NSFetchedResultsController(
                fetchRequest: indicatorRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            super.init()
            outcomesController.delegate = self
            indicatorsController.delegate = self
            do {
                try outcomesController.performFetch()
                try indicatorsController.performFetch()
                outcomes = outcomesController.fetchedObjects ?? []
                indicators = indicatorsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch initial data.")
            }
        }
        /**
         Delegate method to handle changes in the outcomes and indicators controllers.
         - Parameters:
         - controller: The controller that has changed.
         */
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newIndicators = controller.fetchedObjects as? [Indicator] {
                indicators = newIndicators
            } else if let newOutcomes = controller.fetchedObjects as? [Outcome] {
                outcomes = newOutcomes
            }
        }
        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
        func selectedIndicator(with identifier: String) {
            selectedIndicator = dataController.indicator(with: identifier)
        }
    }
}
