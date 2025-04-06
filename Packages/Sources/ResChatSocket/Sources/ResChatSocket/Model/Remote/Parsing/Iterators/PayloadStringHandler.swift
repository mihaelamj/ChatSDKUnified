//
//  PayloadStringHandler.swift
//  
//
//  Created by Mihaela MJ on 02.09.2024..
//

import Foundation

struct PayloadStringHandler {
    
    func extractText(from payloadString: String) -> String? {
        if let textRange = payloadString.range(of: "\"text\": \"") {
            let startIndex = textRange.upperBound
            if let endIndex = findEndOfText(from: payloadString, startingAt: startIndex) {
                return String(payloadString[startIndex..<endIndex])
            }
        }
        return nil
    }
    
    func updateText(in payloadString: String, with newText: String) -> String? {
        if let textRange = payloadString.range(of: "\"text\": \"") {
            let startIndex = textRange.upperBound
            if let endIndex = findEndOfText(from: payloadString, startingAt: startIndex) {
                let newPayloadString = String(payloadString[..<startIndex]) + newText + String(payloadString[endIndex...])
                return newPayloadString
            }
        }
        return nil
    }
    
    private func findEndOfText(from payloadString: String, startingAt startIndex: String.Index) -> String.Index? {
        var isEscaped = false
        var index = startIndex
        
        while index < payloadString.endIndex {
            let character = payloadString[index]
            if character == "\\" {
                isEscaped.toggle()
            } else if character == "\"" && !isEscaped {
                return index
            } else {
                isEscaped = false
            }
            index = payloadString.index(after: index)
        }
        
        return nil
    }
}
