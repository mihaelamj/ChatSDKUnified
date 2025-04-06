//
//  SocketToUIProxy+UIEvent.swift
//
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation
import Combine

// MARK: UI Subscriptions -

internal extension SocketProxy {
    
    func subscribeToSendMessageAction() {
        // Subscribe to the send message event
        uiProviding?.didSendMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                print("uiProviding: User sent message: \(message)")
                self.socketProviding?.sendUserMessage(message)
            }
            .store(in: &cancellables)
    }
    
    func subscribeToSpeechRequest() {
        // Subscribe to the speech button event
        uiProviding?.didTapSpeechButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                print("uiProviding: Speech button tapped")
            }
            .store(in: &cancellables)
    }
    
    func subscribeToMoreMessagesRequest() {
        // Subscribe to the request for more messages
        uiProviding?.didRequestMoreMessagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                print("uiProviding: Request for more messages")
                self.socketProviding?.loadMoreMessages()
            }
            .store(in: &cancellables)
    }
    func subscribeToClearChatRequest() {
        // Subscribe to the clear chat event
        uiProviding?.didRequestToClearChatPublisher
            .receive(on: DispatchQueue.main)  
            .sink { [weak self] in
                guard let self = self else { return }
                
                print("uiProviding: Chat cleared")
                self.socketProviding?.clearChatHistory()
            }
            .store(in: &cancellables)
    }
    
}
