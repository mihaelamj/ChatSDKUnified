//
//  PlatformStuff.swift
//  ResChatHouCommon
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

import ResChatSocket
import ResChatProtocols

// Define the AirportChooserDelegate protocol
public protocol AirportAndLanguageChooserDelegate: AnyObject {
    func didSelectAirport(
        _ airport: Airport,
        language: Language,
        socket: ResChatSocket,
        chatViewController: PlatformChatViewController, 
        chooserViewController: PlatformAirportViewController
    )
}

extension PlatformAirportViewController {
    
    public func handleSelection(delegate: AirportAndLanguageChooserDelegate?,
                         airport: Airport,
                         language: Language,
                         chatViewController: PlatformChatViewController) {
        
        ResChatSocket.language = language.abbreviation
        
        if let location = location {
            ResChatSocket.location = ResChatSocket.Location(latitude: location.coordinate.latitude,
                                                            longitude: location.coordinate.longitude)
        }

        let socket = airport.socket
        
        // Call the delegate method
        chooserDelegate?.didSelectAirport(airport,
                                   language: language,
                                   socket: socket,
                                   chatViewController: chatViewController,
                                   chooserViewController: self)
    }
    
    public weak var chooserDelegate: AirportAndLanguageChooserDelegate? {
        get {
            return genericDelegate as? AirportAndLanguageChooserDelegate
        }
        set {
            genericDelegate = newValue
        }
    }
}
