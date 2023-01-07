//
//  SelectSomething.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/7/23.
//

import SwiftUI

struct SelectSomething: View {
    var body: some View {
        Text("Please select something from the menu to begin.")
            .italic()
            .foregroundColor(.secondary)
    }
}

struct SelectSomething_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomething()
    }
}
