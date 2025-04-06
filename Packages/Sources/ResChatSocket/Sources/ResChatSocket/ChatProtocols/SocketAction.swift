//
//  SocketActions.swift
//  
//
//  Created by Mihaela MJ on 10.09.2024..
//

import Foundation

public protocol SocketAction {
    
    // MARK: - Methods
    
    func connect()
    func disconnect()
    
    /// - `UI` layer responds to button tap, creating a `.placeholder(.forUser)` UIMessageType. and adding it to the table view snapshot
    /// - `UI` layer then, after 2 seconds, creates a `.placeholder(.forBot)` UIMessageType till bot messages start arriving, and adds it to the table view snapshot
    /// - `UI`  triggers the subject firing `didSendMessagePublisher`.
    /// - `Proxy` receives the UI event: `didSendMessagePublisher`.
    /// - `Proxy` calls the method `sendUserMessage` of the `Socket` layer.
    func sendUserMessage(_ message: String)
    
    func loadMoreMessages()
    func clearChatHistory()
    
    /// Determines whether there are more messages to load
    func hasMoreMessagesToLoad() -> Bool
}
