//
//  ResChatSocket+Parse.swift
//
//
//  Created by Mihaela MJ on 05.09.2024..
//

import Foundation
import SocketIO

// MARK: Parse -

internal extension ResChatSocket {
    
    func parseHistory(from data: [Any]) throws -> HistorySnapshot {
        guard let conversations = AnyArrayParser.parseAndUpdateConversationsWithCleanedInput(data) else {
            print("DBGG: Error receiving Conversations data!")
            throw ParsingDataError.conversationsParsingFailed
        }
        
        guard let firstConversation = conversations.first else {
            print("DBGG: Error First conversation is nil!")
            throw ParsingDataError.noConversationsFound
        }
        
        return firstConversation.historySnapshot
    }
    
    func parseStreamingMessages(from data: [Any]) throws -> SocketMessage {
        guard let streamMessages = AnyArrayParser.parseStreamMessagesWithCleanedInput(data) else {
            print("DBGG: Error receiving Stream Message with data!")
            throw ParsingDataError.streamMessagesParsingFailed
        }
        
        guard let firstStreamMessage = streamMessages.first else {
            print("DBGG: Error First StreamMessage is nil!")
            throw ParsingDataError.noStreamMessagesFound
        }
        
        // Convert `StreamMessage` to `SocketMessage`
        return SocketMessage(from: firstStreamMessage)
    }
    
    func parseUpdateItems(from data: [Any]) throws -> SocketMessage {
        guard let historyUpdateItems = AnyArrayParser.parseHistoryUpdateWithCleanedInput(data) else {
            print("DBGG: Error `UpdateHistoryItem`")
            throw ParsingDataError.historyUpdateParsingFailed
        }
        
        guard let firstUpdateHistoryItem = historyUpdateItems.first else {
            print("DBGG: Error First UpdateHistoryItem is nil!")
            throw ParsingDataError.noHistoryUpdateItemsFound
        }
        
        // Convert to `HistoryUpdateItem` `SocketMessage`
        return SocketMessage(from: firstUpdateHistoryItem.updatedItem)
    }
}


