//
//  IndicatorRowViewModel.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/14/23.
//

import Foundation

/**
 Extension to IndicatorRow, providing a view model for IndicatorRow instances.
 */
extension IndicatorRow {
    /**
     The ViewModel class for IndicatorRow instances.
     - Observes:
     - outcome: The Outcome associated with this view model.
     - indicator: The Indicator associated with this view model.
     */
    final class ViewModel: ObservableObject {
        let outcome: Outcome
        let indicator: Indicator
        /**
         Initializes a new view model with the given outcome and indicator.
         - Parameters:
         - outcome: The Outcome associated with this view model.
         - indicator: The Indicator associated with this view model.
         */
        init(outcome: Outcome, indicator: Indicator) {
            self.outcome = outcome
            self.indicator = indicator
        }
        var title: String {
            indicator.indicatorTitle
        }
        /**
         The icon to be displayed for the Indicator associated with this view model.
         - Returns:
         A string containing the name of the icon that should be displayed.
         */
        var icon: String {
            if indicator.completed {
                return "checkmark.circle"
            } else if indicator.proficiency == 1 {
                return "exclamationmark.triangle"
            } else {
                return "checkmark.circle"
            }
        }
        /**
         The color to be displayed for the Indicator associated with this view model.
         - Returns:
         A string containing the color that should be displayed.
         */
        var color: String? {
            if indicator.completed {
                return outcome.outcomeColor
            } else if indicator.proficiency == 1 {
                return outcome.outcomeColor
            } else {
                return nil
            }
        }
        /**
         The label to be displayed for the Indicator associated with this view model.
         - Returns:
         A string containing the label that should be displayed.
         */
        var label: String {
            if indicator.completed {
                return "\(indicator.indicatorTitle), completed"
            } else if indicator.proficiency == 1 {
                return "\(indicator.indicatorTitle), high priority."
            } else {
                return indicator.indicatorTitle
            }
        }
    }
}
