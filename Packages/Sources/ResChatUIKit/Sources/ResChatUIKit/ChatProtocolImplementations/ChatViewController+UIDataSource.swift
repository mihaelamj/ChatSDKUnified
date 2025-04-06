//
//  ChatViewController+UIDataSource.swift
//
//
//  Created by Mihaela MJ on 13.09.2024..
//
#if os(iOS)
import Combine
import Foundation
import ResChatProtocols
import ResChatUICommon

extension ChatViewController {
    
    open override func subscribeToProxyPublishers() {
        // Ensure proxy is set before subscribing to publishers
        guard let proxy = proxy else {
            print("DBGG: Error-> No proxy provided. Skipping subscriptions.")
            return
        }
        
        // Subscribe to connection state changes
        proxy.didChangeConnectionStatePublisher
            .receive(on: DispatchQueue.main)  // Ensures UI updates happen on the main thread
            .sink { [weak self] connectionState in
                let myConnectionState = connectionState.toUIConnectionState
                self?.handleConnectionStateChange(myConnectionState)
            }
            .store(in: &cancellables)

        // Subscribe to message updates
        proxy.didReceiveMessagesPublisher
            .receive(on: DispatchQueue.main)  // Ensures UI updates happen on the main thread
            .sink { [weak self] messages in
                let myMessages = messages.map { $0.toUIMessage()}
                self?.processHistoryMessages(myMessages)
            }
            .store(in: &cancellables)
        
        proxy.didReceiveUpdatedMessagePublisher
            .receive(on: DispatchQueue.main)  // Ensure that UI updates happen on the main thread
            .sink { [weak self] message in
                let myMessage = message.toUIMessage()
                self?.processUpdatedMessage(myMessage) // sending to VC
            }
            .store(in: &cancellables)
        
        proxy.didReceiveStreamingMessagePublisher
            .receive(on: DispatchQueue.main)  // Ensure that UI updates happen on the main thread
            .sink { [weak self] message in
                let myMessage = message.toUIMessage()
                self?.processStreamingMessage(myMessage) // sending to VC
            }
            .store(in: &cancellables)
    }
}
#endif
