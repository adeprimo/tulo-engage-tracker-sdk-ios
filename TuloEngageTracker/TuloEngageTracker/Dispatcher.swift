import Foundation

public protocol Dispatcher {
    
    var eventsURL: URL { get }
        
    func send(event: Event, success: @escaping ()->(), failure: @escaping (_ error: Error)->())
}
