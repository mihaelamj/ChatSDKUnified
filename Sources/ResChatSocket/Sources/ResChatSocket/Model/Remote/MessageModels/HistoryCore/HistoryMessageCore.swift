//
//  HistoryMessageCommon.swift
//  
//
//  Created by Mihaela MJ on 31.08.2024..
//

import Foundation

/// Properties common to `HistoryMessage` & `HistoryUpdatedMessage`

public struct HistoryMessageCore: Codable {
    public var feedbackExplanation: String?
    public var feedbackType: String?
    public var metadata: String?
    public var origin: String
    public var _payload: String // encoded JSON with `Message`
    public var payloadType: String
    public var requestId: String?
    public var timestamp: String
    public var text: String
    public var rawMessageText : String?
    public var decodedMessage: Message
    
    // MARK: Codable -
    
    enum CodingKeys: String, CodingKey {
        case feedbackExplanation = "feedback_explanation"
        case feedbackType = "feedback_type"
        case metadata
        case origin
        case _payload = "payload"
        case payloadType = "payload_type"
        case requestId = "request_id"
        case timestamp
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.feedbackExplanation = try container.decodeIfPresent(String.self, forKey: .feedbackExplanation)
        self.feedbackType = try container.decodeIfPresent(String.self, forKey: .feedbackType)
        self.metadata = try container.decodeIfPresent(String.self, forKey: .metadata)
        self.origin = try container.decode(String.self, forKey: .origin)
        
        self._payload = try container.decode(String.self, forKey: ._payload)
        self.payloadType = try container.decode(String.self, forKey: .payloadType)
        self.requestId = try container.decodeIfPresent(String.self, forKey: .requestId)
        self.timestamp = try container.decode(String.self, forKey: .timestamp)
        self.decodedMessage = Message.fromEncodedPayload(_payload, payloadType: payloadType) ?? Message.none
        self.rawMessageText = _payload.extractRawPayloadText()
        self.text = decodedMessage.text ?? ""
    }
}




