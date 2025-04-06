//
//  ResChatSocket+ SocketAction.swift
//
//
//  Created by Mihaela MJ on 10.09.2024..
//

import Foundation
import Combine

extension ResChatSocket: SocketAction {
    
    // MARK: Methods -
    
    public func connect() {
        _connect()
    }
    
    public func disconnect() {
        _disconnect()
    }
    
    public func sendUserMessage(_ message: String) {
        _sendUserMessage(message)
    }
    
    public func loadMoreMessages() {
        requestMoreMessages()
    }
    
    public func clearChatHistory() {
        _clearChatHistory()
    }
    
    public func hasMoreMessagesToLoad() -> Bool {
        !historyFinishedLoading
    }
}
