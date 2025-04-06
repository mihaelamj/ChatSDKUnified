//
//  StreamMessageResponse.swift
//
//
//  Created by Mihaela MJ on 04.09.2024..
//

import Foundation

struct StreamMessageResponse: Decodable {
    let text: String
    
    enum TopLevelKeys: String, CodingKey {
        case message
    }
    
    enum MessageKeys: String, CodingKey {
        case message
    }
    
    enum InnerMessageKeys: String, CodingKey {
        case elements
    }
    
    enum ElementKeys: String, CodingKey {
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopLevelKeys.self)
        
        // Attempt to decode the message key as a flexible dictionary
        do {
            let rawMessageJSON = try container.decode([String: AnyCodable].self, forKey: .message)
            //            print("Raw message JSON: \(rawMessageJSON)")
            
            // Navigate to the inner "message" field, assuming it's there
            if let innerMessage = rawMessageJSON["message"]?.value as? [String: AnyCodable] {
                //                print("Raw inner message JSON: \(innerMessage)")
                
                // Try to extract the elements array and then the text field
                if let elements = innerMessage["elements"]?.value as? [AnyCodable],
                   let firstElement = elements.first?.value as? [String: AnyCodable] { // Explicitly cast firstElement as a dictionary
                    //                    print("First element JSON: \(firstElement)")
                    if let textValue = firstElement["text"]?.value as? String {
                        self.text = textValue
                        return
                    }
                }
            }
            
            throw DecodingError.dataCorruptedError(forKey: .message, in: container, debugDescription: "MMJ: Could not decode text field")
        } catch {
            print("DBGG: Error decoding 'message' field: \(error)")
            throw error
        }
    }
}
