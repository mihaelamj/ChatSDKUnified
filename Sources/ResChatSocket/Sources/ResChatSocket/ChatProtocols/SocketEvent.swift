//
//  SocketEvent.swift
//  reschatSocket
//
//  Created by Mihaela MJ on 10.09.2024..
//

import Combine

public protocol SocketEvent {
    var didReceiveHistoryMessagesPublisher: AnyPublisher<[SocketMessage], Never> { get }
    var didReceiveStreamingMessagePublisher: AnyPublisher<SocketMessage, Never> { get }
    var didUpdateMessagePublisher: AnyPublisher<SocketMessage, Never> { get }
    var didChangeConnectionStatePublisher: AnyPublisher<SocketConnectionState, Never> { get }
}



