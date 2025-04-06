//
//  ChatViewController+ChatUIEvent.swift
//
//
//  Created by Mihaela MJ on 09.09.2024..
//

import Foundation
import Combine
import ResChatProtocols

// Send my events
// Public-facing publishers that conform to the protocol
extension ChatViewController: UIEvent {
    
    public var didSendMessagePublisher: AnyPublisher<String, Never> {
        didTapSendUserMessageSubject.eraseToAnyPublisher()
    }
    
    public var didTapSpeechButtonPublisher: AnyPublisher<Void, Never> {
        didTapSpeechButtonSubject.eraseToAnyPublisher()
    }
    
    public var didRequestMoreMessagesPublisher: AnyPublisher<Void, Never> {
        didRequestMoreMessagesSubject.eraseToAnyPublisher()
    }
    
    public var didRequestToClearChatPublisher: AnyPublisher<Void, Never> {
        didRequestToClearChatSubject.eraseToAnyPublisher()
    }
    
    public var hasMoreMessagesToLoadPublisher: AnyPublisher<Void, Never> {
        hasMoreMessagesToLoadSubject.eraseToAnyPublisher()
    }
}
