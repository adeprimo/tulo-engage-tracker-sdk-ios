import Foundation

struct Source: Codable {
    let url: Url?
    let referrer: Referrer?
    let browser: Browser?
    let screen: Screen?
    let locale: DeviceLocale?
    
    public init(url: String? = nil, referrer: String? = nil, referrerProtocol: String? = nil) {
        self.url = url != nil ? Url(pathname: url) : nil
        self.referrer = referrer != nil ? Referrer(pathname: referrer, referrerProtocol: referrerProtocol) : nil
        self.screen = Screen()
        self.locale = DeviceLocale()
        self.browser = Browser()
    }
}

struct Url: Codable {
    var pathname: String?
    
    enum CodingKeys: String, CodingKey
    {
        case pathname
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pathname, forKey: .pathname)
    }
}

struct Referrer: Codable {
    var pathname: String?
    var referrerProtocol: String?
    
    enum CodingKeys: String, CodingKey
    {
        case pathname
        case referrerProtocol = "protocol"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pathname, forKey: .pathname)
        try container.encode(referrerProtocol, forKey: .referrerProtocol)
    }
}

struct Browser: Codable {
    var ua: String? = Environment.userAgent
    var name: String? = Environment.bundleName
    var version: String? = Environment.appVersion
    var platform: String = Environment.operatingSystemName
    
    
}

struct Screen: Codable {
    var height: Int = Int(Environment.screenSizeInPixels.height)
    var width:  Int = Int(Environment.screenSizeInPixels.width)
    var colorDepth: Int = 32
}

struct DeviceLocale: Codable {
    var language: String = Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
    var timezone_offset: Int = (0 - TimeZone.current.secondsFromGMT()) / 60
}

extension Locale {
    static var httpAcceptLanguage: String {
        var components: [String] = []
        for (index, languageCode) in preferredLanguages.enumerated() {
            let quality = 1.0 - (Double(index) * 0.1)
            components.append("\(languageCode);q=\(quality)")
            if quality <= 0.5 {
                break
            }
        }
        return components.joined(separator: ",")
    }
}
