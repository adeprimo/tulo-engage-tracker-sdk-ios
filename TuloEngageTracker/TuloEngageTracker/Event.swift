import Foundation

public struct Event: Encodable {
    let clientId: String
    var clientTimestamp: Date?
    let context: Context
    let rootEventId: String
    let sessionId: String
    var user: User?
    var content: Content?
    let eventId: String
    let eventTypeVersion: Int
    let eventType: String
    let eventCustomData: [String: Any]?
    let source: Source
    
    private enum CodingKeys: String, CodingKey {
        case clientId
        case clientTimestamp
        case context
        case rootEventId
        case sessionId
        case user
        case content
        case eventId
        case eventTypeVersion
        case eventType
        case eventCustomData
        case source
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(clientId, forKey: .clientId)
        try container.encode(clientTimestamp, forKey: .clientTimestamp)
        try container.encode(context, forKey: .context)
        try container.encode(rootEventId, forKey: .rootEventId)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(user, forKey: .user)
        try container.encode(content, forKey: .content)
        try container.encode(eventId, forKey: .eventId)
        try container.encode(eventTypeVersion, forKey: .eventTypeVersion)
        try container.encode(eventType, forKey: .eventType)
        try container.encodeAnyIfPresent(eventCustomData, forKey: .eventCustomData)
        try container.encode(source, forKey: .source)
    }
    
}

extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.calendar = Calendar(identifier: .iso8601)
        fullISO8610Formatter.locale = Locale(identifier: "en_US_POSIX")
        fullISO8610Formatter.timeZone = TimeZone(secondsFromGMT: 0)
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        encoder.dateEncodingStrategy = .formatted(fullISO8610Formatter)
        if #available(iOS 11.0, *) {
            encoder.outputFormatting = .sortedKeys
        } else {
            // Fallback on earlier versions
        }
        return try encoder.encode(self)
    }
}

extension Event {
    
    public init(tracker: TuloEngageTracker, eventType: String, eventCustomData: [String: Any]? = nil, url: String? = nil, referrer: String? = nil, referrerProtocol: String? = nil) {
        self.clientId = tracker.clientId
        self.sessionId = tracker.sessionId!
        self.clientTimestamp = Date()
        self.rootEventId = tracker.rootEventId!
        self.context = tracker.context
        //self.user = tracker.user
        //self.content = tracker.content
        self.eventId = NSUUID().uuidString.lowercased()
        self.eventType = eventType
        self.eventTypeVersion = 1
        self.eventCustomData = eventCustomData
        self.source = Source(url: url, referrer: referrer, referrerProtocol: referrerProtocol)
    }
}
