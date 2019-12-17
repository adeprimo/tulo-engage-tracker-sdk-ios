//
//  TuloEngageTracker.swift
//  TuloEngageTracker
//
//  Created by Kari Bengs on 06/02/2019.
//  Copyright © 2019 Adeprimo. All rights reserved.
//

import Foundation

final public class TuloEngageTracker: NSObject {
    
    @objc public var optOut: Bool {
        get {
            return trackerUserDefaults.optOut
        }
        set {
            trackerUserDefaults.optOut = newValue
            user = User.current(in: trackerUserDefaults)
        }
    }
    
       
    internal var trackerUserDefaults: TrackerUserDefaults
    internal var user: User?
    internal var content: Content?
    private let dispatcher: Dispatcher
    internal let context: Context
    internal var sessionId: String?
    internal let clientId: String
    internal var rootEventId: String?
    internal var url: String

    
    @objc public var logger: Logger = DefaultLogger(minLevel: .warning)
    
    internal static var _sharedInstance: TuloEngageTracker?
    
    required public init(organizationId: String, productId: String, dispatcher: Dispatcher) {
        self.context = Context(organizationId: organizationId, productId: productId)
       
        self.trackerUserDefaults = TrackerUserDefaults(suiteName: "\(organizationId)\(productId)")
        if let existingClientId = trackerUserDefaults.clientId {
            self.clientId = existingClientId
        } else {
            let newClientId = UUID().uuidString.lowercased()
            trackerUserDefaults.clientId = newClientId
            self.clientId = newClientId
        }
        
        self.user = User.current(in: trackerUserDefaults)
        self.dispatcher = dispatcher;
       
        self.url = "/"
        super.init()
        newRootEventId()
        startSession()
    }
    
    @objc convenience public init(organizationId: String, productId: String, eventUrl: URL) {
        let dispatcher = URLSessionDispatcher(baseURL: eventUrl )
        self.init(organizationId: organizationId, productId: productId, dispatcher: dispatcher)
    }
}

extension TuloEngageTracker {
    
    public func startSession() {
        let newSessionId = UUID().uuidString.lowercased()
        trackerUserDefaults.sessionId = newSessionId
        self.sessionId = newSessionId
    }
    
    public func newRootEventId() {
        let newRootEventId = UUID().uuidString.lowercased()
        trackerUserDefaults.rootEventId = newRootEventId
        self.rootEventId = newRootEventId
    }
}

extension TuloEngageTracker {
    
    @objc public func trackEvent(name: String, customData: String? = nil, eventPrefix: String = "app") {
        trackEvent(name: eventPrefix + ":" + name, customData: customData, trackData: false)
    }
    
    @objc public func trackEventWithContentData(name: String, customData: String? = nil, url: String? = nil, referrer: String? = nil, referrerProtocol: String? = nil, eventPrefix: String = "app") {
        trackEvent(name: eventPrefix + ":" + name, customData: customData, url: url, referrer: referrer, referrerProtocol: referrerProtocol, trackData: true, isNewRoot: true)
    }
    
    @objc public func trackPageView(url: String, referrer: String? = nil, referrerProtocol: String? = nil, eventPrefix: String = "app") {
        trackEvent(name:  eventPrefix + ":pageview", url: url, referrer: referrer, referrerProtocol: referrerProtocol, trackData: true, isNewRoot: true)
    }
    
    @objc public func trackArticleView(customData: String, eventPrefix: String = "app") {
        trackEvent(name: eventPrefix + ":pageview", customData: customData, trackData: true)
    }
    
    @objc public func trackArticleInteraction(type: String, eventPrefix: String = "app") {
        let data = "{\"type\": \"\(type)\"}"
        
        trackEvent(name: eventPrefix + ":article.interaction", customData: data, trackData: true)
    }
    
    @objc public func trackArticlePurchase(customData: String, eventPrefix: String = "app") {
        trackEvent(name: eventPrefix + ":article.purchase", customData: customData, trackData: true)
    }
    
    @objc public func trackArticleActiveTime(startTime: Date, endTime: Date, eventPrefix: String = "app") {
        let activetime = try? ActiveTime(startTime: startTime, endTime: endTime).encode()
        let data = String(data: activetime!, encoding: .utf8)
        trackEvent(name: eventPrefix + ":activetime", customData: data, trackData: true)
    }
    
    @objc public func trackArticleRead(customData: String, eventPrefix: String = "app") {
        trackEvent(name: eventPrefix + ":article.read", customData: customData, trackData: true)
    }
    
    private func trackEvent(name: String, customData: String? = nil, url: String? = nil, referrer: String? = nil, referrerProtocol: String? = nil, trackData: Bool, isNewRoot: Bool = false) {
        //if url != nil && self.url != url {
        
        var json: [String: AnyObject]? = nil
        
        if customData != nil {
            let data = customData?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject]
            } catch let error as NSError {
               self.logger.warning("Failed to serialize customData with error \(error)")
            }
        }
        
        if isNewRoot {
            if url != nil && self.url != url {
                newRootEventId()
                self.url = url!
            }
        }
        var event = Event(tracker:self, eventType: name, eventCustomData: json, url: url, referrer: referrer, referrerProtocol: referrerProtocol)
        if let userData = self.user {
            event.user = userData
        }
        if trackData {
            if let contentData = self.content {
                event.content = contentData
            }
        }
        let eventData = try? event.encode()
        let jsonData = String(data: eventData!, encoding: .utf8)
        self.logger.debug(jsonData ?? "")
        guard !optOut else { return }
        self.dispatcher.send(event: event, success: {
            self.logger.info("Dispatched event")
        }, failure: { error in
            self.logger.warning("Failed dispatching events with error \(error)")
        })
    }
    
    @objc public func setUser(userId: String? = "", paywayId: String? = "", states: [String]? = [], products: [String]? = [], positionLon: String? = "", positionLat: String? = "", location: String? = "", persist: Bool = false) {
        if userId != "" {
            self.user!.userId = userId
            if persist {
                trackerUserDefaults.userId = userId
            }
        }
        if paywayId != "" {
            self.user!.paywayId = paywayId
            if persist {
                trackerUserDefaults.paywayId = paywayId
            }
        }
        if states != [] {
            self.user!.states = states
            if persist {
                trackerUserDefaults.states = states
            }
        }
        if products != [] {
            self.user!.products = products
            if persist {
                trackerUserDefaults.products = products
            }
        }
        if positionLon != "" {
            self.user!.positionLon = positionLon
            if persist {
                trackerUserDefaults.positionLon = positionLon
            }
        }
        if positionLat != "" {
            self.user!.positionLat = positionLat
            if persist {
                trackerUserDefaults.positionLat = positionLat
            }
        }
        if location != "" {
            self.user!.location = location
            if persist {
                trackerUserDefaults.location = location
            }
        }

    }
    
    @objc public func setContent(state: String? = nil, type: String? = nil, articleId: String? = nil, publishDate: Date? = nil, title: String? = nil, section: String? = nil, keywords: [String]? = nil, authorId: [String]? = nil, articleLon: String? = nil, articleLat: String? = nil) {
        self.content = Content(state: state, type: type, articleId: articleId, publishDate: publishDate, title: title, section: section, keywords: keywords, authorId: authorId, articleLon: articleLon, articleLat: articleLat)
    }
    
}
