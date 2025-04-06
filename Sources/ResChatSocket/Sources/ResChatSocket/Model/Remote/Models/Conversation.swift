//
//  Conversation.swift
//  
//
//  Created by Mihaela MJ on 21.08.2024..
//

import Foundation

public struct Conversation: Codable { // HistorySnapshotResponseDto
    let conversationId: String?
    public let historySnapshot: HistorySnapshot

    enum CodingKeys: String, CodingKey {
        case conversationId = "conversation_id"
        case historySnapshot = "history_snapshot"
    }
}


