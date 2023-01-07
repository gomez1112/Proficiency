//
//  Award.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/7/23.
//

import Foundation

struct Award: Decodable, Identifiable {
    var id: String { name }
    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String
    
    static let allAwards: [Award] = Bundle.main.load("Awards")
    static let example = allAwards[0]
}
