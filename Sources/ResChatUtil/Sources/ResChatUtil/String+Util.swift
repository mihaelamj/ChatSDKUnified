//
//  String+Util.swift
//  ResChatUtil
//
//  Created by Mihaela MJ on 22.09.2024..
//

import Foundation

public extension String {
    
    // Helper: Pretty-print JSON array and return it as a String
    static func prettyPrintedJSON(from array: [Any]) -> String? {
        guard JSONSerialization.isValidJSONObject(array) else {
            return nil
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            return "Error serializing array to JSON: \(error)"
        }
        return nil
    }
    
    static func summarizeString(_ input: String?, upTo count: Int) -> String? {
        guard let input = input else { return nil }
        let prefixString = String(input.prefix(count))
        let remainingCharacters = input.count - prefixString.count
        let summary = "\(prefixString) (+ \(remainingCharacters) characters)"
        return summary
    }
}
