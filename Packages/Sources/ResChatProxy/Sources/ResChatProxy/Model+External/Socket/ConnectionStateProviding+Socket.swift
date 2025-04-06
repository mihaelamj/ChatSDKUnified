//
//  UIConnectionStateProviding+Socket.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation
import ResChatSocket
import ResChatProtocols

extension SocketConnectionState: ConnectionStateProviding {
    public var toConnectionState: ConnectionState {
        switch self {
        case .connected:
            return ConnectionState.connected
        case .disconnected:
            return ConnectionState.disconnected
        case .loading:
            return ConnectionState.loading
        case .loaded:
            return ConnectionState.loaded
        case .error(let error):
            return ConnectionState.error(error)
        case .loadingMore:
            return ConnectionState.loadingMore
        case .loadedMore:
            return ConnectionState.loadedMore
        }
    }
}

extension ConnectionState {
    public var toSocketConnectionState: SocketConnectionState {
        switch self {
        case .connected:
            return SocketConnectionState.connected
        case .disconnected:
            return SocketConnectionState.disconnected
        case .loading:
            return SocketConnectionState.loading
        case .loaded:
            return SocketConnectionState.loaded
        case .error(let error):
            return SocketConnectionState.error(error)
        case .loadingMore:
            return SocketConnectionState.loadingMore
        case .loadedMore:
            return SocketConnectionState.loadedMore
        }
    }
}

