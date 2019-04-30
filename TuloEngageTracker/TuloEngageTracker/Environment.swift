import Foundation
import UIKit

internal struct Environment {
    
    internal static let appVersion: String = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }()
    
    internal static let bundleName: String = {
        return Bundle.main.infoDictionary?["CFBundleName"] as! String
    }()
    
    internal static let userAgent: String = {
        return "\(bundleName)/\(appVersion) (\(deviceModelString); \(operatingSystemName) \(operatingSystemVersionString))"
        
    }()
    
    // Returns the screen size in pixels
    internal static let screenSizeInPixels: CGSize = {
        let bounds = UIScreen.main.nativeBounds
        return bounds.size
    }()
    
    // Returns the screen size in points
    internal static let screenSizeInPoints: CGSize = {
        let bounds = UIScreen.main.bounds
        return bounds.size
    }()
    
    internal static let deviceModelString: String = {
        
        //define if this is call from simulator. Required for testing.
        #if targetEnvironment(simulator)
        
        return "iPhone"
        
        #else
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
        
        #endif
    }()
    
    internal static let operatingSystemName: String = {
        #if os(iOS)
        return "iOS"
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(tvOS)
        return "tvOS"
        #endif
    }()
    
    internal static let operatingSystemVersionString: String = {
        let version = ProcessInfo().operatingSystemVersion
        
        if version.patchVersion == 0 {
            return "\(version.majorVersion).\(version.minorVersion)"
        } else {
            return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
        }
    }()
}
