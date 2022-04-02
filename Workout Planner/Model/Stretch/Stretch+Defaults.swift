//
//  Stretch+Defaults.swift
//  Stretch+Defaults
//

import Foundation
import CoreData

extension Stretch {
    
    struct DefaultStretches: Decodable {
        var defaultStretches: [DefaultStretch]
    }

    struct DefaultStretch: Decodable {
        var name: String
        var picture: String
        var category: String
    }
}
