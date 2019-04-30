import Foundation
import UIKit

public final class URLSessionDispatcher: Dispatcher {
    
    private let timeout: TimeInterval
    private let session: URLSession
    public let eventsURL: URL
    
    public init(baseURL: URL) {
        self.eventsURL = baseURL
        self.timeout = 5
        self.session = URLSession.shared
    }
    
    public func send(event: Event, success: @escaping ()->(), failure: @escaping (_ error: Error)->()) {
        let jsonBody: Data
        do {
            jsonBody = try event.encode()
        } catch  {
            failure(error)
            return
        }
        let request = buildRequest(url: eventsURL, method: "POST", contentType: "application/json; charset=utf-8", body: jsonBody)
        send(request: request, success: success, failure: failure)
    }
    
    private func buildRequest(url: URL, method: String, contentType: String? = nil, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)
        request.httpMethod = method
        body.map { request.httpBody = $0 }
        contentType.map { request.setValue($0, forHTTPHeaderField: "Content-Type") }
        return request
    }
    
    private func send(request: URLRequest, success: @escaping ()->(), failure: @escaping (_ error: Error)->()) {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
        task.resume()
    }
    
}
