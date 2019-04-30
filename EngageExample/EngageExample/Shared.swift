import Foundation
import TuloEngageTracker

extension TuloEngageTracker {
    static let shared: TuloEngageTracker = {
        let engageTracker = TuloEngageTracker(organizationId: "wot", productId: "PEIWEI", eventUrl: URL(string: "http://localhost:8080/api/v1/events")!)
        engageTracker.logger = DefaultLogger(minLevel: .debug)
        engageTracker.optOut = false
        return engageTracker
    }()
}
