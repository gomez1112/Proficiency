//
//  Tag+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import Foundation

extension Tag: RawRepresentable {
    typealias RawValue = String
    var rawValue: RawValue {
        switch self {
        case .home:
            return "home"
        case .open:
            return "open"
        case .closed:
            return "closed"
        case .award:
            return "awards"
        }
    }
    init?(rawValue: RawValue) {
        switch rawValue {
        case "home": self = .home
        case "open": self = .open
        case "closed": self = .closed
        case "awards": self = .award
        default:
            return nil
        }
    }
}
