//
//  User.swift
//  TuloEngageTracker
//
//  Created by Kari Bengs on 08/02/2019.
//  Copyright © 2019 Adeprimo. All rights reserved.
//

import Foundation

struct User: Codable {
    var userId: String?
    var paywayId: String?
    var states: [String]?
    var products: [String]?
    var positionLon: String?
    var positionLat: String?
    var location: String?
}

extension User {
    static func current(in trackerUserDefaults: TrackerUserDefaults) -> User {
        let trackerUserDefaults = trackerUserDefaults
        let userId = trackerUserDefaults.userId
        let paywayId = trackerUserDefaults.paywayId
        let states = trackerUserDefaults.states
        let products = trackerUserDefaults.products
        let location = trackerUserDefaults.location
        let positionLon = trackerUserDefaults.positionLon
        let positionLat = trackerUserDefaults.positionLat
        
        return User(userId: userId, paywayId: paywayId, states: states, products: products, positionLon: positionLon, positionLat: positionLat,location: location)
    }
}
