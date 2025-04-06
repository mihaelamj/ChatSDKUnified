//
//  ResChatSocket+SocketState.swift
//
//
//  Created by Mihaela MJ on 02.09.2024..
//

import Foundation

public enum SocketConnectionState {
    case connected
    case disconnected
    case loading
    case loaded
    case loadingMore
    case loadedMore
    case error(Error?)
    
    // Custom equality check function
    public func isEqualTo(_ other: SocketConnectionState) -> Bool {
        switch (self, other) {
        case (.connected, .connected):
            return true
        case (.disconnected, .disconnected):
            return true
        case (.loading, .loading):
            return true
        case (.loadingMore, .loadingMore):
            return true
        case (.loaded, .loaded):
            return true
        case (.loadedMore, .loadedMore):
            return true
        case (.error(let selfError), .error(let otherError)):
            // Compare errors by their localized description (optional comparison)
            return selfError?.localizedDescription == otherError?.localizedDescription
        default:
            return false
        }
    }
    
    // Equatable conformance
    public static func == (lhs: SocketConnectionState, rhs: SocketConnectionState) -> Bool {
        lhs.isEqualTo(rhs)
    }
    
    // Conforming to Hashable
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .connected:
            hasher.combine("connected")
        case .disconnected:
            hasher.combine("disconnected")
        case .loading:
            hasher.combine("loading")
        case .loaded:
            hasher.combine("loaded")
        case .loadingMore:
            hasher.combine("loadingMore")
        case .loadedMore:
            hasher.combine("loadedMore")
        case .error(let error):
            hasher.combine("error")
            if let errorDescription = error?.localizedDescription {
                hasher.combine(errorDescription)
            }
        }
    }
    
    var name: String {
        switch self {
        case .connected:
            return "connected"
        case .disconnected:
            return "disconnected"
        case .loading:
            return "loading"
        case .loaded:
            return "loaded"
        case .error(let error):
            return "error"
        case .loadingMore:
            return "loadingMore"
        case .loadedMore:
            return "loadedMore"
        }
    }
}




