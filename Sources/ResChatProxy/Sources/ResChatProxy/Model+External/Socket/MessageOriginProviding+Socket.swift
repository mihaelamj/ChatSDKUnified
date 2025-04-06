//
//  MessageOriginProviding+Socket.swift
//  reschatproxy
//
//  Created by Mihaela MJ on 18.09.2024..
//

import Foundation
import ResChatSocket
import ResChatProtocols

extension SocketMessageSource: @retroactive MessageOriginProviding {
    public var toMessageOrigin: MessageOrigin {
        switch self {
        case .history:
            return MessageOrigin.history
        case .historyUpdateItem:
            return MessageOrigin.updateItem
        case .streaming:
            return MessageOrigin.streaming
        }
    }
}

