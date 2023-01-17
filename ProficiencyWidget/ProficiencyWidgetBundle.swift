//
//  ProficiencyWidgetBundle.swift
//  ProficiencyWidget
//
//  Created by Gerard Gomez on 1/16/23.
//

import WidgetKit
import SwiftUI

@main
struct ProficiencyWidgetBundle: WidgetBundle {
    var body: some Widget {
        SimpleProficiencyWidget()
        ComplexProficiencyWidget()
        ProficiencyLockScreenWidget()
       // ProficiencyWidgetLiveActivity()
    }
}
