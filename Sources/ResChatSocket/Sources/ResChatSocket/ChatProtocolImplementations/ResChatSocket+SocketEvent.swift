//
//  ResChatSocket+ SocketEvent.swift
//
//
//  Created by Mihaela MJ on 10.09.2024..
//

import Foundation
import Combine

extension ResChatSocket: SocketEvent {
    
    // MARK: Providers -
    
    public var didReceiveStreamingMessagePublisher: AnyPublisher<SocketMessage, Never> {
        streamingMessage
    }
    
    public var didUpdateMessagePublisher: AnyPublisher<SocketMessage, Never> {
        updatedMessage
    }
    
    public var didReceiveHistoryMessagesPublisher: AnyPublisher<[SocketMessage], Never> {
        messages
    }
    
    public var didChangeConnectionStatePublisher: AnyPublisher<SocketConnectionState, Never> {
        connectionState
    }
}
