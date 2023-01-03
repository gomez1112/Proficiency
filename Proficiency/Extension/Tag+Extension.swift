//
//  Tag+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/2/23.
//

import Foundation

extension Tag: RawRepresentable {
    var rawValue: String {
        switch self {
        case .home:
            return "home"
        case .open:
            return "open"
        case .closed:
            return "closed"
        }
    }
    
    init?(rawValue: String) {
        switch rawValue {
        case "home": self = .home
        case "open": self = .open
        case "closed": self = .closed
        default:
            return nil
        }
    }
}
