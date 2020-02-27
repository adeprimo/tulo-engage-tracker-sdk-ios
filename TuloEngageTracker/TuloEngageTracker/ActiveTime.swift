import Foundation

struct ActiveTime: Encodable {
    let startTime: Date
    let endTime: Date
    var secondsActive: Int {
        return Int(endTime.timeIntervalSince(startTime))
    }
    
    private enum CodingKeys: String, CodingKey {
        case activeTime
        case startTime
        case endTime
        case secondsActive
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .activeTime)
        try response.encode(startTime, forKey: .startTime)
        try response.encode(endTime, forKey: .endTime)
        try response.encode(secondsActive, forKey: .secondsActive)
    }
}
