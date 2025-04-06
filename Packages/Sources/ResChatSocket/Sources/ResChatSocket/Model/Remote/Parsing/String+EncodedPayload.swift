//
//  CommonHistoryMessageData+Decode.swift
//
//
//  Created by Mihaela MJ on 31.08.2024..
//

import Foundation

// MARK: Encoded Payload -

public extension String {
    
    func fixPayloadTextPart() -> String {
        let payloadHandler = PayloadStringHandler()
        let payloadString = self
        
        guard let text = payloadHandler.extractText(from: self) else {
            return payloadString
        }
        
        let cleanedText = AnyArrayParser.cleanText(text)
        
        if let updatedPayloadString = payloadHandler.updateText(in: payloadString, with: cleanedText) {

            return updatedPayloadString
        }
        
        return payloadString
    }
    
    func decodeToMessagePayload() -> Message? {
        let fixedString = self.fixPayloadTextPart()
        guard let data = fixedString.data(using: .utf8) else { return nil }
        
        do {
            let decoder = JSONDecoder()
            let decodedPayload = try decoder.decode(Message.self, from: data)
            return decodedPayload
        } catch let DecodingError.dataCorrupted(context) {
            // Handle specific decoding error with context
            print("DBGG: Error decoding MessagePayload: \(context.debugDescription)")
            if let underlyingError = context.underlyingError as NSError? {
                ErrorHelper.handleDecodingError(error: underlyingError, in: self)
            }
            return nil
        } catch let error as NSError {
            // Handle other decoding errors
            ErrorHelper.handleDecodingError(error: error, in: self)
            return nil
        }
    }
    
    func extractRawPayloadText() -> String? {
        let payloadHandler = PayloadStringHandler()
        return payloadHandler.extractText(from: self)
    }
}

// MARK: Helper -

internal extension Message {
    static func fromEncodedPayload(_ payload: String, payloadType: String) -> Message? {
        (payloadType == "message") ? payload.decodeToMessagePayload() : nil
    }
}

public extension String {

    func removingEscapesExceptNewlines() -> String {
        let newLine = "__NEWLINE__"
        let escape = "____ESCAPE____"
        let escapedQuote = "____ESCAPED_QUOTE____"
        let escapedApos = "____ESCAPED_APO____"
        var result = self
        result = result.replacingOccurrences(of: "\n", with: newLine)
        result = result.replacingOccurrences(of: "\'", with: escapedApos)
        result = result.replacingOccurrences(of: "\\", with: escape)
        result = result.replacingOccurrences(of: "\"", with: escapedQuote)
        
        result = result.replacingOccurrences(of: escape, with: "")
        result = result.replacingOccurrences(of: escapedApos, with: "'")
        result = result.replacingOccurrences(of: escapedQuote, with: "")
//        result = result.replacingOccurrences(of: newLine, with: "\n") // FIXME: I'm losing newlines -
        result = result.replacingOccurrences(of: newLine, with: "")
        
        return result
    }
    
    func removingControlCharacters() -> String {
        let result = locateAndFixControlCharacters(in: self)
        return result
    }
    
    // Function to sanitize the JSON string by escaping problematic characters
    func locateAndFixControlCharacters(in jsonString: String) -> String {
        var fixedString = ""
        
        // Iterate over each character in the string
        for char in jsonString.unicodeScalars {
            if (char.value >= 0x00 && char.value <= 0x1F) || char.value == 0x7F {
                // Replace control character with an empty string
                fixedString.append("")
            } else {
                fixedString.append(String(char))
            }
        }
        
        return fixedString
    }
    
    
}



