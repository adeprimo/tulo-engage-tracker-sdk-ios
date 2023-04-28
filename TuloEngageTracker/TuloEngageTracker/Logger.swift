import Foundation

@objc public enum LogLevel: Int {
    case verbose = 10
    case debug = 20
    case info = 30
    case warning = 40
    case error = 50
    
    var title: String {
        switch self {
        case .error: return "Error"
        case .warning: return "Warning"
        case .info: return "Info"
        case .debug: return "Debug"
        case .verbose: return "Verbose"
        }
    }
}

@objc public protocol Logger {
    func log(_ message: @autoclosure () -> String, level: LogLevel)
}

extension Logger {
    func verbose(_ message: @autoclosure () -> String) {
        log(message(), level: .verbose)
    }
    func debug(_ message: @autoclosure () -> String) {
        log(message(), level: .debug)
    }
    func info(_ message: @autoclosure () -> String) {
        log(message(), level: .info)
    }
    func warning(_ message: @autoclosure () -> String) {
        log(message(), level: .warning)
    }
    func error(_ message: @autoclosure () -> String) {
        log(message(), level: .error)
    }
}

@objc public final class DefaultLogger: NSObject, Logger {
    private let dispatchQueue = DispatchQueue(label: "DefaultLogger", qos: .background)
    private let minLevel: LogLevel
    
    @objc public var enabled = true
    
    @objc public init(minLevel: LogLevel) {
        self.minLevel = minLevel
        super.init()
    }
    
    public func log(_ message: @autoclosure () -> String, level: LogLevel) {
        guard enabled && level.rawValue >= minLevel.rawValue else { return }
        let messageToPrint = message()
        dispatchQueue.async {
            print("TuloEngageTracker [\(level.title)] \(messageToPrint)")
        }
    }
}
