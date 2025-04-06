//
//  UIConnectionState+Convert.swift
//
//
//  Created by Mihaela MJ on 16.09.2024..
//

import Combine
import Foundation
import ResChatProtocols

extension ResChatProtocols.ConnectionState {
    public var toUIConnectionState: UIConnectionState {
        switch self {
        case .connected:
            return UIConnectionState.connected
        case .disconnected:
            return UIConnectionState.disconnected
        case .loading:
            return UIConnectionState.loading
        case .loaded:
            return UIConnectionState.loaded
        case .error(let error):
            return UIConnectionState.error(error)
        case .loadingMore:
            return UIConnectionState.loadingMore
        case .loadedMore:
            return UIConnectionState.loadedMore
        }
    }
}

