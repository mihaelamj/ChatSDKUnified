//
//  HistoryMessage.swift
//
//
//  Created by Mihaela MJ on 02.08.2024..
//

import Foundation

public struct HistoryMessage: Codable, MessageParents, HistoryMessageCoreProviding {
    
    // MARK: Common Properties -
    
    public var common: HistoryMessageCore
    
    // MARK: MessageParents Properties -
    
    public var conversationId: String?
    public var historyId: String?
    
    // MARK: Specific Properties -
    
    public var index: Int
    public var session: Session
    
    // MARK: Codable -
    
    enum CodingKeys: String, CodingKey {
        case index
        case session
    }
    
    // MARK: init -
    
    // Custom initializer to decode common and other properties // called from Conversations, 
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the common properties
        self.common = try HistoryMessageCore(from: decoder)
        
        // Decode the specific properties
        self.index = try container.decode(Int.self, forKey: .index)
        self.session = try container.decode(Session.self, forKey: .session)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode the common properties
        try common.encode(to: encoder)
        
        // Encode the specific properties
        try container.encode(index, forKey: .index)
        try container.encode(session, forKey: .session)
    }
}

// MARK: MessageUnityProviding -

extension HistoryMessage: MessageUnityProviding {
    
    public var socketSource: SocketMessageSource { .history }
    
    public var messageIndex: Int { index }
}
