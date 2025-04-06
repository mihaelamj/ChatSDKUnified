//
//  SocketError.swift
//
//
//  Created by Mihaela MJ on 06.09.2024..
//

import Foundation

enum ParsingDataError: Error {
    case conversationsParsingFailed
    case noConversationsFound
    case streamMessagesParsingFailed
    case noStreamMessagesFound
    case historyUpdateParsingFailed
    case noHistoryUpdateItemsFound
    
    var localizedDescription: String {
        switch self {
        case .conversationsParsingFailed:
            return "Error parsing Conversations data."
        case .noConversationsFound:
            return "No Conversations found."
        case .streamMessagesParsingFailed:
            return "Error parsing Stream Messages data."
        case .noStreamMessagesFound:
            return "No Stream Messages found."
        case .historyUpdateParsingFailed:
            return "Error parsing UpdateHistoryItem data."
        case .noHistoryUpdateItemsFound:
            return "No UpdateHistoryItem available."
        }
    }
}

enum UnknownStateError: Error {
    case unknownState(message: String)
}
