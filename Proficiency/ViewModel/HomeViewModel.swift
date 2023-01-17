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
        @Published var upNext = ArraySlice<Indicator>()
        @Published var moreToExplore = ArraySlice<Indicator>()
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
            let indicatorRequest = dataController.fetchRequestForTopIndicators(count: 10)
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
                upNext = indicators.prefix(3)
                moreToExplore = indicators.dropFirst(3)
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
            indicators = indicatorsController.fetchedObjects ?? []
            upNext = indicators.prefix(3)
            moreToExplore = indicators.dropFirst(3)
            outcomes = outcomesController.fetchedObjects ?? []
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
