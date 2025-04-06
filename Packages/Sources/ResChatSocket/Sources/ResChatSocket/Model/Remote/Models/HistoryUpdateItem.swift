//
//  HistoryUpdateItem.swift
//
//
//  Created by Mihaela MJ on 31.08.2024..
//

import Foundation

public struct HistoryUpdateItem: Codable {
    
    // MARK: Properties -
    
    let conversationId: String?
    let updatedItem: HistoryUpdatedMessage
    
    enum CodingKeys: String, CodingKey {
        case conversationId = "conversation_id"
        case updatedItem = "updated_item"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.conversationId = try container.decodeIfPresent(String.self, forKey: .conversationId)
        
        // Decode `updatedItem` and inject the `conversationId`
        let tempUpdatedItem = try container.decode(HistoryUpdatedMessage.self, forKey: .updatedItem)
        self.updatedItem = tempUpdatedItem.with(conversationId: conversationId, historyId: nil)
    }
}
