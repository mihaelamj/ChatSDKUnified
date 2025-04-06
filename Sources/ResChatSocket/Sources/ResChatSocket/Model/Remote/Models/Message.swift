//
//  Message.swift
//  
//
//  Created by Mihaela MJ on 21.08.2024..
//

import Foundation

public struct Message: Codable {

    public let debugInfo: String?
    public var messageDetails: MessageDetails
    public let sources: String?
    public let thoughtProcess: String?
    
    enum CodingKeys: String, CodingKey {
        case debugInfo = "debug_info"
        case message
        case sources
        case thoughtProcess = "thought_process"
    }
    
    internal init(debugInfo: String? = nil, message: MessageDetails, sources: String? = nil, thoughtProcess: String? = nil) {
        self.debugInfo = debugInfo
        self.messageDetails = message
        self.sources = sources
        self.thoughtProcess = thoughtProcess
    }
    
    // Custom initializer for decoding, called from Collections
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each property individually
        debugInfo = try container.decodeIfPresent(String.self, forKey: .debugInfo)
        messageDetails = try container.decode(MessageDetails.self, forKey: .message) // TODO: Do this manually -
        sources = try container.decodeIfPresent(String.self, forKey: .sources)
        thoughtProcess = try container.decodeIfPresent(String.self, forKey: .thoughtProcess)
    }
    
    // Encode method (optional, as Codable will auto-generate it if needed)
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(debugInfo, forKey: .debugInfo)
        try container.encode(messageDetails, forKey: .message)
        try container.encodeIfPresent(sources, forKey: .sources)
        try container.encodeIfPresent(thoughtProcess, forKey: .thoughtProcess)
    }
    
    public var text: String? {
        messageDetails.elements.first { $0.element == "text" }?.text
    }
    
    public static var none: Message {
        return Message(
            debugInfo: nil,
            message: MessageDetails.none,
            sources: nil,
            thoughtProcess: nil
        )
    }
}
