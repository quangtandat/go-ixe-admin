

import UIKit
import SystemConfiguration
let ReachabilityDidChangeNotificationName = "ReachabilityDidChangeNotification"

enum ReachabilityStatus {
    case notReachable
    case reachableViaWiFi
    case reachableViaWWAN
}
class DXReachabilitySwift: NSObject {
    private var networkReachability: SCNetworkReachability?
    /**
     This function can return nil, if it's not able to create a valid SCNetworkReachability object. So, our initializer will be a failable initializer:

     - parameter hostName: creates a SCNetworkReachability object with the SCNetworkReachabilityCreateWithName function

     */
    init?(hostName: String) {
        networkReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, (hostName as NSString).utf8String!)
        super.init()
        if networkReachability == nil {
            return nil
        }
    }

    /**
     create an additional initializer for cases where we want to create a reachability reference to the network address. In this case we will use the SCNetworkReachabilityCreateWithAddress function. As this function expects a pointer to a network address, we will call it inside a withUnsafePointer function

     - parameter hostAddress: create a reachability reference to the network address. Use the SCNetworkReachabilityCreateWithAddress function

     */
    init?(hostAddress: sockaddr_in) {
        var address = hostAddress

        guard let defaultRouteReachability = withUnsafePointer(to: &address, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }) else {
            return nil
        }

        networkReachability = defaultRouteReachability

        super.init()
        if networkReachability == nil {
            return nil
        }
    }

    /**
     Creates a reachability instance to control if we are connected to internet.

     - returns: reachability instance
     */
    static func networkReachabilityForInternetConnection() -> DXReachabilitySwift? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        return DXReachabilitySwift(hostAddress: zeroAddress)
    }

    /**
     Creates a reachability instance to control if we are connected to internet, allows to check if we are connected to a local WiFi

     - return: reachability instance
     */

    static func networkReachabilityForLocalWiFi() -> DXReachabilitySwift? {
        var localWifiAddress = sockaddr_in()
        localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
        localWifiAddress.sin_family = sa_family_t(AF_INET)
        // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0 (0xA9FE0000).
        localWifiAddress.sin_addr.s_addr = 0xA9FE0000

        return DXReachabilitySwift(hostAddress: localWifiAddress)
    }

    private var notifying: Bool = false
    /**
     To start notifying, we first check that we are not already doing so. Then, we get a SCNetworkReachabilityContext and we assign self to its info parameter. After that we set the callback function, passing also the context (when the callback function is called, the info parameter that contains a reference to self will be passed as pointer to a data block as third parameter).
     - return: Bool If setting the callback function is successful, we can then schedule the network reachability reference in a run loop.
     */

    func startNotifier() -> Bool {

        guard notifying == false else {
            return false
        }

        var context = SCNetworkReachabilityContext()
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())

        guard let reachability = networkReachability, SCNetworkReachabilitySetCallback(reachability, { (target: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
            if let currentInfo = info {
                let infoObject = Unmanaged<AnyObject>.fromOpaque(currentInfo).takeUnretainedValue()
                if infoObject is DXReachabilitySwift {
                    let networkReachability = infoObject as! DXReachabilitySwift
                    NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityDidChangeNotificationName), object: networkReachability)
                }
            }
            }, &context) == true else { return false }

        guard SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) == true else { return false }
        
        notifying = true
        return notifying
    }

    /**
     To stop notifying, we just unschedule the network reachability reference from the run loop
     */

    func stopNotifier() {
        if let reachability = networkReachability, notifying == true {
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
            notifying = false
        }
    }

    deinit {
        stopNotifier()
    }

    private var flags: SCNetworkReachabilityFlags {

        var flags = SCNetworkReachabilityFlags(rawValue: 0)

        if let reachability = networkReachability, withUnsafeMutablePointer(to: &flags, { SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0)) }) == true {
            return flags
        }
        else {
            return []
        }
    }

    var currentReachabilityStatus: ReachabilityStatus {

        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        } 
        else {
            return .notReachable
        }
    }

    var isReachable: Bool {
        switch currentReachabilityStatus {
        case .notReachable:
            return false
        case .reachableViaWiFi, .reachableViaWWAN:
            return true
        }
    }

}
