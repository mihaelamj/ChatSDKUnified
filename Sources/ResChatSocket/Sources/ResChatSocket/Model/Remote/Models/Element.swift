//
//  Element.swift
//  
//
//  Created by Mihaela MJ on 21.08.2024..
//

import Foundation

public struct Element: Codable {
    public let attachment: String?
    public let element: String
    public let htmlToMarkdown: Bool
    public let text: String
    
    enum CodingKeys: String, CodingKey {
        case attachment
        case element
        case htmlToMarkdown = "html_to_markdown"
        case text
    }
    
    // Custom initializer for decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each property individually
        attachment = try container.decodeIfPresent(String.self, forKey: .attachment)
        element = try container.decode(String.self, forKey: .element)
        htmlToMarkdown = try container.decode(Bool.self, forKey: .htmlToMarkdown)
        text = try container.decode(String.self, forKey: .text)
    }
}
