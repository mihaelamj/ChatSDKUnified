//
//  UIConnectionState.swift
//
//
//  Created by Mihaela MJ on 04.09.2024..
//

import Foundation

public enum UIConnectionState {
    case connected
    case disconnected
    case loading
    case loaded
    case loadingMore
    case loadedMore
    case error(Error?)
    
    public func toString() -> String {
        switch self {
        case .connected:
            return "connected"
        case .disconnected:
            return "disconnected"
        case .loading:
            return "loading"
        case .loaded:
            return "loaded"
        case .loadingMore:
            return "loadingMore"
        case .loadedMore:
            return "loadedMore"
        case .error(let error):
            if let err = error {
                return "error: \(err.localizedDescription)"
            } else {
                return "error"
            }
        }
    }
    
    // Hashable conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(toString())
    }
    
    // Equatable conformance (optional since it's derived automatically for enums without associated values)
    public static func == (lhs: UIConnectionState, rhs: UIConnectionState) -> Bool {
        switch (lhs, rhs) {
        case (.connected, .connected),
             (.disconnected, .disconnected),
             (.loading, .loading),
             (.loaded, .loaded),
             (.loadingMore, .loadingMore),
             (.loadedMore, .loadedMore):
            return true
        case let (.error(lhsError), .error(rhsError)):
            return lhsError?.localizedDescription == rhsError?.localizedDescription
        default:
            return false
        }
    }
}

