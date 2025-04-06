//
//  ConnectionStateProviding.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 14.09.2024..
//

import Foundation

public protocol ConnectionStateProviding: Hashable, Equatable {
    var toConnectionState: ConnectionState { get }
}

public extension ConnectionStateProviding {
    static var none: ConnectionState {
        .disconnected
    }
}
