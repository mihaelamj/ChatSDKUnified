//
//  ResChatSocket+SocketKeys.swift
//  
//
//  Created by Mihaela MJ on 31.08.2024..
//

import Foundation

public extension ResChatSocket {
    enum SocketMessageKey: String {
        case sendMessage = "send_message"
        case requestHistorySnapshot = "request_history_snapshot"
        case requestWelcomeMessage = "request_welcome_message"
        case clearHistory = "clear_history"
    }

    enum SocketEventKey: String {
        case connect = "connect"
        case disconnect = "disconnect"
        case error = "error"
        case sendHistorySnapshot = "send_history_snapshot"
        case streamMessage = "stream_message"
        case updateHistoryItem = "update_history_item"
    }
    
    enum SocketKey: String {
        case connectionId = "connection_id"
        case appId = "app_id"
        case metadata = "metadata"
        case externalAgentId = "external_agent_id"
        case conversationId = "conversation_id"
        case lastMessageTs = "last_message_ts"
        case snapshotSize = "snapshot_size"
        case message = "message"
    }
}
