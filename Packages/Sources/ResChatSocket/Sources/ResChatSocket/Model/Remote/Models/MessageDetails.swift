//
//  MessageDetails.swift
//  
//
//  Created by Mihaela MJ on 21.08.2024..
//

import Foundation

public struct MessageDetails: Codable {
    
    internal init(elements: [Element], 
                  notificationText: String? = nil,
                  renderOnlyFor: [String],
                  surface: String) {
        self.elements = elements
        self.notificationText = notificationText
        self.renderOnlyFor = renderOnlyFor
        self.surface = surface
    }
    
    public let elements: [Element]
    public let notificationText: String?
    public let renderOnlyFor: [String]
    public let surface: String
    
    enum CodingKeys: String, CodingKey {
        case elements
        case notificationText = "notification_text"
        case renderOnlyFor = "render_only_for"
        case surface
    }
    
    // Custom initializer for decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each property with custom handling if necessary
        elements = try container.decode([Element].self, forKey: .elements)
        notificationText = try container.decodeIfPresent(String.self, forKey: .notificationText)
        renderOnlyFor = try container.decodeIfPresent([String].self, forKey: .renderOnlyFor) ?? []
        surface = try container.decode(String.self, forKey: .surface)
    }
    
    // Encode method (optional, as Codable will auto-generate it if needed)
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(elements, forKey: .elements)
        try container.encodeIfPresent(notificationText, forKey: .notificationText)
        try container.encode(renderOnlyFor, forKey: .renderOnlyFor)
        try container.encode(surface, forKey: .surface)
    }
    
    // Static variable for an empty implementation
    public static var none: MessageDetails {
        return MessageDetails(
            elements: [],
            notificationText: nil,
            renderOnlyFor: [],
            surface: ""
        )
    }
    
    
}

