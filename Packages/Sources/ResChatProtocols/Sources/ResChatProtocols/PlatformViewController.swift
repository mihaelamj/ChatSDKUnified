//
//  PlatformViewController.swift
//  ResChatProtocols
//
//  Created by Mihaela MJ on 17.09.2024..
//

#if canImport(UIKit)
import UIKit
public typealias PlatformViewController = UIViewController
#elseif canImport(AppKit)
import AppKit
public typealias PlatformViewController = NSViewController
#endif

import CoreLocation

extension PlatformViewController {
    @objc open class func make() -> Self {
        Self()
    }
    
    // Generic function to make a chooser controller for any type conforming to PlatformAirportViewController
    public static func makeChooserController<T: PlatformAirportViewController>(ofType type: T.Type) -> T {
        let chooserVC = type.make()
        chooserVC.genericDelegate = self
        return chooserVC
    }
}

// Define a protocol for the ChatViewController that both iOS and macOS versions will conform to
public protocol PlatformChatViewController: AnyObject {
    var proxy: UIDataSource? { get set }
    func subscribeToProxyPublishers()
}

public protocol PlatformAirportViewController: AnyObject {
    var location: CLLocation? { get set } // Add CLLocation property
    var genericDelegate: AnyObject? { get set } // Add delegate property
    static func make() -> Self
}

// Associated keys for storing proxy values using Objective-C runtime
private struct AssociatedKeys {
    static var proxy = "proxyKey"
    static var location = "locationKey"
    static var delegateKey = "delegateKey"
}

// swiftlint:disable unsafe_raw_pointer
// Extend UIViewController and NSViewController to conform to PlatformChatViewController protocol
extension PlatformViewController: PlatformChatViewController {
    // The proxy property, with didSet to trigger subscriptions
    public var proxy: UIDataSource? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.proxy) as? UIDataSource
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.proxy,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // If you anticipate potential multi-threaded access, consider switching to `OBJC_ASSOCIATION_RETAIN` for thread safety.
            subscribeToProxyPublishers() // Automatically subscribe when the proxy is set
        }
    }
    
    // Define the required method to handle proxy subscriptions
    @objc open func subscribeToProxyPublishers() {
        // Add logic to subscribe to proxy-related publishers
        print("Subscribing to proxy publishers")
    }
}

extension PlatformViewController: PlatformAirportViewController {
    // The location property, using Objective-C runtime to store the value
    public var location: CLLocation? {
        get {
            return objc_getAssociatedObject(self, UnsafeRawPointer(&AssociatedKeys.location)) as? CLLocation
        }
        set {
            objc_setAssociatedObject(self, UnsafeRawPointer(&AssociatedKeys.location), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // A generic delegate property
    public var genericDelegate: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.delegateKey) as AnyObject?
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.delegateKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // Call a method when the delegate is set, if needed
            if let delegate = newValue as? NSObject {
                handleDelegateSet(delegate)
            }
        }
    }
    
    // This method can be used to handle the delegate being set
    private func handleDelegateSet(_ delegate: NSObject) {
        // Perform any setup or subscribe actions when the delegate is set
        print("Delegate has been set: \(delegate)")
    }
}
// swiftlint:enable unsafe_raw_pointer

