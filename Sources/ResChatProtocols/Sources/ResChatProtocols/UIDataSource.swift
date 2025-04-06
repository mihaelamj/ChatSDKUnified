//
//  UIDataSource.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation
import Combine

// Received data from Socket into generic data types (MessageProviding, ConnectionState) that a specific UI needs to convert to its own types -

public protocol UIDataSource: AnyObject {
    var didReceiveUpdatedMessagePublisher: AnyPublisher<MessageProviding, Never> { get }
    var didReceiveStreamingMessagePublisher: AnyPublisher<MessageProviding, Never> { get }
    var didReceiveMessagesPublisher: AnyPublisher<[MessageProviding], Never> { get }
    var didChangeConnectionStatePublisher: AnyPublisher<ConnectionState, Never> { get }
}
