//
//  Profile+Defaults.swift
//  Profile+Defaults
//

import Foundation
import CoreData

extension Profile {

    struct DefaultProfiles: Decodable {
        var defaultProfile: [DefaultProfile]
    }
    
    struct DefaultProfile: Decodable {

        var firstName: String
        var lastName: String
        var email: String
        var weightUnit: String?
        var theme: String?
        var countdown: Double
    }
}
