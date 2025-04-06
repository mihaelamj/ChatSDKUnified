//
//  AnyArrayParser.swift
//  
//
//  Created by Mihaela MJ on 01.09.2024..
//

import Foundation

public struct AnyArrayParser {
    
    enum SanitizerType {
        case escapes
        case controlCharacters
        
        public static func findDifferencesBetween(_ string1: String, _ string2: String) -> [(index: Int, char1: Character?, char2: Character?)] {
            let maxLength = max(string1.count, string2.count)
            var differences: [(index: Int, char1: Character?, char2: Character?)] = []

            for i in 0..<maxLength {
                let char1 = i < string1.count ? string1[string1.index(string1.startIndex, offsetBy: i)] : nil
                let char2 = i < string2.count ? string2[string2.index(string2.startIndex, offsetBy: i)] : nil

                if char1 != char2 {
                    differences.append((index: i, char1: char1, char2: char2))
                }
            }

            return differences
        }
    }
    
    static func cleanText(_ text: String) -> String {
        var cleanedText = text
        switch AnyArrayParser.sanitizerType {
        case .escapes:
            cleanedText = text.removingEscapesExceptNewlines()
        case .controlCharacters:
            cleanedText = text.removingControlCharacters()
        }
        
        if text != cleanedText {
            let diffs = SanitizerType.findDifferencesBetween(text, cleanedText)
            print("Text clean diffs: \(diffs)")
        }
        return cleanedText
    }
    
    static let sanitizerType: SanitizerType = .controlCharacters
    
    // Generic method to parse any type conforming to Decodable
    static func parse<T: Decodable>(_ anyArray: [Any], as type: T.Type) -> [T]? {
        let dataString = AnyArrayParser.jsonDataToString(anyArray) ?? ""
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [])
            let items = try JSONDecoder().decode([T].self, from: jsonData)
            return items
        } catch let DecodingError.dataCorrupted(context) {

            if let underlyingError = context.underlyingError as NSError? {
                ErrorHelper.handleDecodingError(error: underlyingError, in: dataString)
            }
            return nil
        } catch let error as NSError {
            // Handle other decoding errors
            ErrorHelper.handleDecodingError(error: error, in: dataString)
            return nil
        }
    }
    
}

// MARK: Helper -

public extension AnyArrayParser {
    static func jsonDataToString(_ anyArray: [Any]) -> String? {
        do {
            // Convert the anyArray to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [])
            
            // Convert JSON data to a string for logging purposes
            let dataString = String(data: jsonData, encoding: .utf8)
            return dataString
        } catch {
            print("Failed to convert AnyArray to String: \(error)")
            return nil
        }
    }
    
    static func jsonStringToArray(_ jsonString: String) -> [Any]? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("DBGG: Error converting string to Data.")
            return nil
        }
        
        do {
            let anyArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any]
            return anyArray
        } catch {
            print("DBGG: Error parsing JSON: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: Base Parsers -

public extension AnyArrayParser {

    static func parseStreamMessages(_ anyArray: [Any]) -> [StreamMessage]? {
        return parse(anyArray, as: StreamMessage.self)
    }
    
    static func parseHistoryUpdateItems(_ anyArray: [Any]) -> [HistoryUpdateItem]? {
        return parse(anyArray, as: HistoryUpdateItem.self)
    }
    
    static func parseConversations(_ anyArray: [Any]) -> [Conversation]? {
        return parse(anyArray, as: Conversation.self)
    }
    
    static func parseAndUpdateConversations(_ anyArray: [Any]) -> [Conversation]? {
        guard let conversations = parseConversations(anyArray) else {
            return nil
        }

        return conversations.map { conversation in
            updateConversation(conversation)
        }
    }
}

// MARK: Base Parsers -

public extension AnyArrayParser {
    
    static func parseStreamMessagesWithCleanedInput(_ anyArray: [Any]) -> [StreamMessage]? {
        parse(anyArray, as: StreamMessage.self) ?? 
        parse(fixStreamMessageTexts(in: anyArray), as: StreamMessage.self)
    }
    
    static func parseConversationsWithCleanedInput(_ anyArray: [Any]) -> [Conversation]? {
        parse(anyArray, as: Conversation.self) ??
        parse(fixHistorySnapshotTexts(in: anyArray), as: Conversation.self)
    }
    
    static func parseHistoryUpdateWithCleanedInput(_ anyArray: [Any]) -> [HistoryUpdateItem]? {
        parse(anyArray, as: HistoryUpdateItem.self) ??
        parse(fixHistoryUpdateItemTexts(in: anyArray), as: HistoryUpdateItem.self)
    }
    
    static func parseAndUpdateConversationsWithCleanedInput(_ anyArray: [Any]) -> [Conversation]? {
        
        guard let conversations = parseConversationsWithCleanedInput(anyArray) else {
            return nil
        }

        return conversations.map { conversation in
            updateConversation(conversation)
        }
    }
}

// MARK: Fixing Parsers -

public extension AnyArrayParser {
    
    static func fixStreamMessageTexts(in anyArray: [Any]) -> [Any] {
        var iterator = StreamMessageTextFieldIterator(anyArray: anyArray)

        while let (_, text) = iterator.next() {
            
            let cleanedText = Self.cleanText(text)

            iterator.updateCurrentText(with: cleanedText)
        }
        
        let updatedArray = iterator.getUpdatedArray()
        return updatedArray
    }
    
    static func fixHistorySnapshotTexts(in anyArray: [Any]) -> [Any] {
        var iterator = HistoryPayloadIterator(anyArray: anyArray)

        while let (_, _, text) = iterator.next() {
            
            let cleanedText = Self.cleanText(text)
            
            iterator.updateCurrentText(with: cleanedText)
        }
        
        let updatedArray = iterator.getUpdatedArray()
        return updatedArray
    }
    
    static func fixHistoryUpdateItemTexts(in anyArray: [Any]) -> [Any] {
        var iterator = UpdatedItemPayloadIterator(anyArray: anyArray)

        while let (_, _, text) = iterator.next() {
            
            let cleanedText = Self.cleanText(text)
            
            iterator.updateCurrentText(with: cleanedText)
        }
        
        let updatedArray = iterator.getUpdatedArray()
        return updatedArray
    }
}

// MARK: Text Replacing --

public extension AnyArrayParser {
    
    // Function to replace the content of "text" fields within the [Any] array with an array of new texts
    
    static func replaceTextFieldsWithArray(in anyArray: [Any], newTexts: [String]) -> [Any]? {
        var mutableAnyArray = anyArray
        var textIndex = 0

        // Iterate over each dictionary (representing each message) in the array
        for i in 0..<mutableAnyArray.count {
            if var messageDict = mutableAnyArray[i] as? [String: Any],
               var innerMessageDict = messageDict["message"] as? [String: Any],
               var elements = innerMessageDict["elements"] as? [[String: Any]] {
                
                // Iterate over elements to find the "text" field
                for j in 0..<elements.count {
                    if elements[j]["element"] as? String == "text" {
                        // Replace the entire content of the "text" field with the corresponding text from newTexts
                        if textIndex < newTexts.count {
                            elements[j]["text"] = newTexts[textIndex]
                            textIndex += 1
                        }
                    }
                }
                
                // Update the inner message dictionary
                innerMessageDict["elements"] = elements
                messageDict["message"] = innerMessageDict
                mutableAnyArray[i] = messageDict
            }
        }

        return mutableAnyArray
    }
}


// MARK: Helpers -

private extension AnyArrayParser {
    private static func updateConversation(_ conversation: Conversation) -> Conversation {
        let conversationId = conversation.conversationId ?? ""
        let historyId = conversation.historySnapshot.historyId

        let updatedMessages = conversation.historySnapshot.messages.map { message in
            message.with(conversationId: conversationId, historyId: historyId)
        }

        return Conversation(
            conversationId: conversation.conversationId,
            historySnapshot: HistorySnapshot(
                historyId: historyId,
                messages: updatedMessages,
                messagesAfter: conversation.historySnapshot.messagesAfter,
                messagesBefore: conversation.historySnapshot.messagesBefore,
                snapshotSize: conversation.historySnapshot.snapshotSize
            )
        )
    }
    
}


// MARK: Parsers -

public extension AnyArrayParser {
    static func parseConversationsOld(_ anyArray: [Any]) -> [Conversation]? {
        let dataString = AnyArrayParser.jsonDataToString(anyArray) ?? ""
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [])
            let conversations = try JSONDecoder().decode([Conversation].self, from: jsonData)
            
            // Use map to iterate over conversations and set conversationId and historyId
            let updatedConversations = conversations.map { conversation -> Conversation in
                let conversationId = conversation.conversationId ?? ""
                let historyId = conversation.historySnapshot.historyId
                
                // Update the history messages with conversationId and historyId
                let updatedMessages = conversation.historySnapshot.messages.map { message in
                    message.with(conversationId: conversationId, historyId: historyId)
                }
                
                // Return a new Conversation instance with updated messages
                return Conversation(
                    conversationId: conversation.conversationId,
                    historySnapshot: HistorySnapshot(
                        historyId: historyId,
                        messages: updatedMessages,
                        messagesAfter: conversation.historySnapshot.messagesAfter,
                        messagesBefore: conversation.historySnapshot.messagesBefore,
                        snapshotSize: conversation.historySnapshot.snapshotSize
                    )
                )
            }
            
            return updatedConversations
        } catch let DecodingError.dataCorrupted(context) {
            // Handle specific decoding error with context
            print("DBGG: Error decoding: \(context.debugDescription)")
            
            if let underlyingError = context.underlyingError as NSError? {
                ErrorHelper.handleDecodingError(error: underlyingError, in: dataString)
            }
            return nil
        } catch let error as NSError {
            // Handle other decoding errors
            ErrorHelper.handleDecodingError(error: error, in: dataString)
            return nil
        }
    }
    
    static func parseStreamMessagesOld(_ anyArray: [Any]) -> [StreamMessage]? {
        let dataString = AnyArrayParser.jsonDataToString(anyArray) ?? ""
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [])
            let streamMessages = try JSONDecoder().decode([StreamMessage].self, from: jsonData)
            return streamMessages
        } catch let DecodingError.dataCorrupted(context) {
            // Handle specific decoding error with context
            print("DBGG: Error decoding: \(context.debugDescription)")
            
            if let underlyingError = context.underlyingError as NSError? {
                ErrorHelper.handleDecodingError(error: underlyingError, in: dataString)
            }
            return nil
        } catch let error as NSError {
            // Handle other decoding errors
            ErrorHelper.handleDecodingError(error: error, in: dataString)
            return nil
        }
    }
    
    static func parseHistoryUpdateItemsOld(_ anyArray: [Any]) -> [HistoryUpdateItem]? {
        
        let dataString = AnyArrayParser.jsonDataToString(anyArray) ?? ""
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [])
            let items = try JSONDecoder().decode([HistoryUpdateItem].self, from: jsonData)
            return items
        } catch let DecodingError.dataCorrupted(context) {
            // Handle specific decoding error with context
            print("DBGG: Error decoding: \(context.debugDescription)")
            
            if let underlyingError = context.underlyingError as NSError? {
                ErrorHelper.handleDecodingError(error: underlyingError, in: dataString)
            }
            return nil
        } catch let error as NSError {
            // Handle other decoding errors
            ErrorHelper.handleDecodingError(error: error, in: dataString)
            return nil
        }
    }
}
