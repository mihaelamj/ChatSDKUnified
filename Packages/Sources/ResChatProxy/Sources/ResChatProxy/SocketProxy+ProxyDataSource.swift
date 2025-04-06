//
//  SocketToUIProxy+UIDataSource.swift
//  
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation
import Combine
import ResChatSocket
import ResChatProtocols

extension SocketProxy: UIDataSource {
    public var didReceiveUpdatedMessagePublisher: AnyPublisher<any ResChatProtocols.MessageProviding, Never> {
        _didReceiveUpdatedMessagePublisher.eraseToAnyPublisher()
    }
    
    public var didReceiveStreamingMessagePublisher: AnyPublisher<any ResChatProtocols.MessageProviding, Never> {
        _didReceiveStreamingMessagePublisher.eraseToAnyPublisher()
    }
    
    public var didReceiveMessagesPublisher: AnyPublisher<[any ResChatProtocols.MessageProviding], Never> {
        _didReceiveMessagesPublisher.eraseToAnyPublisher()
    }
    
    public var didChangeConnectionStatePublisher: AnyPublisher<ResChatProtocols.ConnectionState, Never> {
        _didChangeConnectionStatePublisher.eraseToAnyPublisher()
    }
}
