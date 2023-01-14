//
//  IndicatorRowViewModel.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/14/23.
//

import Foundation

extension IndicatorRow {
    final class ViewModel: ObservableObject {
        let outcome: Outcome
        let indicator: Indicator
        init(outcome: Outcome, indicator: Indicator) {
            self.outcome = outcome
            self.indicator = indicator
        }
        var title: String {
            indicator.indicatorTitle
        }
        var icon: String {
            if indicator.completed {
                return "checkmark.circle"
            } else if indicator.proficiency == 1 {
                return "exclamationmark.triangle"
            } else {
                return "checkmark.circle"
            }
        }
        var color: String? {
            if indicator.completed {
                return outcome.outcomeColor
            } else if indicator.proficiency == 1 {
                return outcome.outcomeColor
            } else {
                return nil
            }
        }
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
