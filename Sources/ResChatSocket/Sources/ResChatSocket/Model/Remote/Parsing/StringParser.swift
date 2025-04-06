//
//  StringParser.swift
//  
//
//  Created by Mihaela MJ on 01.09.2024..
//

import Foundation

// MARK: String Parsers -

public struct StringParser {
    static func parseObjectFromString<T: Decodable>(_ jsonString: String, as type: T.Type) -> T? {
        do {
            guard let jsonData = jsonString.data(using: .utf8) else {
                print("DBGG: Error converting string to Data.")
                return nil
            }
            let item = try JSONDecoder().decode(T.self, from: jsonData)
            return item
        } catch let DecodingError.dataCorrupted(context) {
            // Handle specific decoding error with context
            print("DBGG: Error decoding: \(context.debugDescription)")
            
            if let underlyingError = context.underlyingError as NSError? {
                ErrorHelper.handleDecodingError(error: underlyingError, in: jsonString)
            }
            return nil
        } catch let error as NSError {
            // Handle other decoding errors
            ErrorHelper.handleDecodingError(error: error, in: jsonString)
            return nil
        }
    }
    
    // Parses an array of objects from a JSON string
    static func parseObjectsFromString<T: Decodable>(_ jsonString: String, as type: T.Type) -> [T]? {
        do {
            guard let jsonData = jsonString.data(using: .utf8) else {
                print("DBGG: Error converting string to Data.")
                return nil
            }
            let items = try JSONDecoder().decode([T].self, from: jsonData)
            return items
        } catch let DecodingError.dataCorrupted(context) {
            // Handle specific decoding error with context
            print("DBGG: Error decoding: \(context.debugDescription)")
            
            if let underlyingError = context.underlyingError as NSError? {
                ErrorHelper.handleDecodingError(error: underlyingError, in: jsonString)
            }
            return nil
        } catch let error as NSError {
            // Handle other decoding errors
            ErrorHelper.handleDecodingError(error: error, in: jsonString)
            return nil
        }
    }
}


// MARK: Arrays -

public extension StringParser {
    static func parseConversationsFromString(_ jsonString: String) -> [Conversation]? {
        return parseObjectsFromString(jsonString, as: Conversation.self)
    }
    
    static func parseHistoryUpdateItemsFromString(_ jsonString: String) -> [HistoryUpdateItem]? {
        return parseObjectsFromString(jsonString, as: HistoryUpdateItem.self)
    }
    
    static func parseStreamMessagessFromString(_ jsonString: String) -> [StreamMessage]? {
        return parseObjectsFromString(jsonString, as: StreamMessage.self)
    }
}

// MARK: Items -

public extension StringParser {
    
    // Specific function for parsing a single Conversation from string
    static func parseConversationFromString(_ jsonString: String) -> Conversation? {
        return parseObjectFromString(jsonString, as: Conversation.self)
    }
    
    // Specific function for parsing a single HistoryUpdateItem from string
    static func parseHistoryUpdatedMessageFromString(_ jsonString: String) -> HistoryUpdatedMessage? {
        return parseObjectFromString(jsonString, as: HistoryUpdatedMessage.self)
    }
    
    // Specific function for parsing a single HistoryUpdateItem from string
    static func parseHistoryMessageFromString(_ jsonString: String) -> HistoryMessage? {
        return parseObjectFromString(jsonString, as: HistoryMessage.self)
    }
    
    static func parseStreamMessageFromString(_ jsonString: String) -> StreamMessage? {
        return parseObjectFromString(jsonString, as: StreamMessage.self)
    }
    
    static func parseMessageFromString(_ jsonString: String) -> Message? {
        return parseObjectFromString(jsonString, as: Message.self)
    }
}
