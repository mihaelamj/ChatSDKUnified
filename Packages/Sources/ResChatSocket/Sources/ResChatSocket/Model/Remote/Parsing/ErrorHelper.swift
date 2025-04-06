//
//  ErrorHelper.swift
//  
//
//  Created by Mihaela MJ on 01.09.2024..
//

import Foundation

public struct ErrorHelper {
    // Helper function for calculating line and column
    private static func findLineAndColumn(in jsonString: String, at index: Int) -> (line: Int, column: Int) {
        let lines = jsonString.prefix(index).split(separator: "\n", omittingEmptySubsequences: false)
        let line = lines.count
        let column = lines.last?.count ?? 0
        return (line, column)
    }
    
    // Error handling function
    static func handleDecodingError(error: NSError, in jsonString: String) {
        print("Decoding error: \(error.localizedDescription)")

        // If available, extract the specific error index
        if let errorIndex = error.userInfo["NSJSONSerializationErrorIndex"] as? Int {
            
            // Calculate line and column
            let (line, column) = findLineAndColumn(in: jsonString, at: errorIndex)
            
            // Extract and print the offending part of the string
            let offendingCharacter = jsonString[jsonString.index(jsonString.startIndex, offsetBy: errorIndex)]
            print("Offending string (starting): \(jsonString.dropFirst(errorIndex).prefix(50))")
            print("Offending character: '\(offendingCharacter)' at index \(errorIndex), line \(line), column \(column)")
        } else {
            print("Underlying error not found or index not available.")
        }
    }
}

/**
 Error Data exampl
 [
   "Tried emitting when not connected"
 ]
 */
