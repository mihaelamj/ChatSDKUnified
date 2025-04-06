//
//  StreamMessage.swift
//  
//
//  Created by Mihaela MJ on 01.08.2024..
//

import Foundation

public struct StreamMessage: Codable, MessageParents {

    // MARK: MessageParents Properties -
    
    public var conversationId: String?
    public var historyId: String?
    
    // MARK: Specific Properties -
    
    public let isFinal: Bool
    public let message: Message
    public let messagePart: Int
    public let messageId: String
    public let rawMessageText : String?
    
    // MARK: Codable -
    
    enum CodingKeys: String, CodingKey {
        case conversationId = "conversation_id"
        case isFinal = "is_final"
        case message
        case messageId = "message_id"
        case messagePart = "message_part"
    }
    
    // MARK: init -
    
    internal init(conversationId: String? = nil, 
                  historyId: String? = nil,
                  isFinal: Bool,
                  message: Message,
                  messagePart: Int,
                  messageId: String,
                  rawMessageString: String) {
        self.conversationId = conversationId
        self.historyId = historyId
        self.isFinal = isFinal
        self.message = message
        self.messagePart = messagePart
        self.messageId = messageId
        self.rawMessageText = rawMessageString.extractRawPayloadText()
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conversationId = try container.decodeIfPresent(String.self, forKey: .conversationId)
        isFinal = try container.decode(Bool.self, forKey: .isFinal)
        messageId = try container.decode(String.self, forKey: .messageId)
        messagePart = try container.decode(Int.self, forKey: .messagePart)
        message = try container.decode(Message.self, forKey: .message)
        
        // Use StreamMessageResponse to extract the text
        let streamMessageResponse = try StreamMessageResponse(from: decoder)
        rawMessageText = streamMessageResponse.text
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode each property individually
        try container.encodeIfPresent(conversationId, forKey: .conversationId)
        try container.encode(isFinal, forKey: .isFinal)
        try container.encode(messageId, forKey: .messageId)
        try container.encode(messagePart, forKey: .messagePart)
        try container.encode(message, forKey: .message)
    }
}

// MARK: MessageUnityProviding -

extension StreamMessage: MessageUnityProviding {
    public var payload: String? { nil }
    
    public var text: String { myMessage.text ?? "" }
    
    public var rawText: String? { rawMessageText }
    
    public var socketSource: SocketMessageSource { .streaming }
    
    public var myMessage: Message { message }
    
    public var messageTimestamp: String { messageId }
    
    public var isBotMessage: Bool { true }
    
    public var isMessageFinished: Bool { isFinal }
    
    public var messagePartNumber: Int { messagePart }
}


