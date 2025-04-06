//
//  HistorySnapshot.swift
//  
//
//  Created by Mihaela MJ on 21.08.2024..
//

import Foundation

public struct HistorySnapshot: Codable {
    public let historyId: String
    public let messages: [HistoryMessage] // MessageDto
    public let messagesAfter: Int
    public let messagesBefore: Int
    public let snapshotSize: Int

    enum CodingKeys: String, CodingKey {
        case historyId = "history_id"
        case messages
        case messagesAfter = "messages_after"
        case messagesBefore = "messages_before"
        case snapshotSize = "snapshot_size"
    }
}
