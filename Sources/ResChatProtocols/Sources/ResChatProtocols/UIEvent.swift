//
//  UIEvent.swift
//
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation
import Combine

public protocol UIEvent {
    var didSendMessagePublisher: AnyPublisher<String, Never> { get }
    var didTapSpeechButtonPublisher: AnyPublisher<Void, Never> { get }
    var didRequestMoreMessagesPublisher: AnyPublisher<Void, Never> { get }
    var didRequestToClearChatPublisher: AnyPublisher<Void, Never> { get }
}
