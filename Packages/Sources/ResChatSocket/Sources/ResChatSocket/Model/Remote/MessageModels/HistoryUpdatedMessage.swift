//
//  File.swift
//  
//
//  Created by Mihaela MJ on 31.08.2024..
//

import Foundation

// HistoryUpdatedMessage struct
public struct HistoryUpdatedMessage: Codable, MessageParents, HistoryMessageCoreProviding {
    
    // MARK: Common Properties -
    
    public var common: HistoryMessageCore
    
    // MARK: MessageParents Properties -
    
    public var conversationId: String?
    public var historyId: String?
    
    // MARK: Specific Properties -
    
    public var updateTimestamp: String
    
    // MARK: Codable -
    
    enum CodingKeys: String, CodingKey {
        case updateTimestamp = "update_timestamp"
    }
    
    // Custom initializer to decode common and other properties
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the common properties
        self.common = try HistoryMessageCore(from: decoder)
        
        // Decode the specific properties
        self.updateTimestamp = try container.decode(String.self, forKey: .updateTimestamp)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode the common properties
        try common.encode(to: encoder)
        
        // Encode the specific properties
        try container.encode(updateTimestamp, forKey: .updateTimestamp)
    }
}

// MARK: MessageUnityProviding -

extension HistoryUpdatedMessage: MessageUnityProviding {
    
    public var socketSource: SocketMessageSource { .historyUpdateItem }
}
