//
//  TrackerUserDefaults.swift
//  TuloEngageTracker
//
//  Created by Kari Bengs on 08/02/2019.
//  Copyright © 2019 Adeprimo. All rights reserved.
//

import Foundation

internal struct TrackerUserDefaults {
    let userDefaults: UserDefaults
    
    init(suiteName: String?) {
        userDefaults = UserDefaults(suiteName: suiteName)!
    }
    
    var clientId: String? {
        get {
            return userDefaults.string(forKey: "clientId")
        }
        set {
            userDefaults.setValue(newValue, forKey: "clientId")
            userDefaults.synchronize()
        }
    }
    
    var userId: String? {
        get {
            return userDefaults.string(forKey: "userId")
        }
        set {
            userDefaults.setValue(newValue, forKey: "userId")
            userDefaults.synchronize()
        }
    }
    
    var paywayId: String? {
        get {
            return userDefaults.string(forKey: "paywayId")
        }
        set {
            userDefaults.setValue(newValue, forKey: "paywayId")
            userDefaults.synchronize()
        }
    }
    
    var sessionId: String? {
        get {
            return userDefaults.string(forKey: "sessionId")
        }
        set {
            userDefaults.setValue(newValue, forKey: "sessionId")
            userDefaults.synchronize()
        }
    }
    
    var rootEventId: String? {
        get {
            return userDefaults.string(forKey: "rootEventId")
        }
        set {
            userDefaults.setValue(newValue, forKey: "rootEventId")
            userDefaults.synchronize()
        }
    }
    
    var states: [String]? {
        get {
            return userDefaults.value(forKey:  "states") as? [String]
        }
        set {
            userDefaults.setValue(newValue, forKey: "states")
            userDefaults.synchronize()
        }
    }
    
    var products: [String]? {
        get {
            return userDefaults.value(forKey:  "products") as? [String]
        }
        set {
            userDefaults.setValue(newValue, forKey: "products")
            userDefaults.synchronize()
        }
    }
    
    var location: String? {
        get {
            return userDefaults.string(forKey: "location")
        }
        set {
            userDefaults.setValue(newValue, forKey: "location")
            userDefaults.synchronize()
        }
    }
    
    var positionLon: String? {
        get {
            return userDefaults.string(forKey: "positionLon")
        }
        set {
            userDefaults.setValue(newValue, forKey: "positionLon")
            userDefaults.synchronize()
        }
    }
    
    var positionLat: String? {
        get {
            return userDefaults.string(forKey: "positionLat")
        }
        set {
            userDefaults.setValue(newValue, forKey: "positionLat")
            userDefaults.synchronize()
        }
    }
    
    var optOut: Bool {
        get {
            return userDefaults.bool(forKey: "optOut")
        }
        set {
            userDefaults.setValue(newValue, forKey: "optOut")
            userDefaults.synchronize()
        }
    }
}
