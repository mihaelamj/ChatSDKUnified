//
//  AnyCodable.swift
//  
//
//  Created by Mihaela MJ on 04.09.2024..
//

import Foundation

struct AnyCodable: Codable {
    let value: Any?

    init(_ value: Any?) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = nil
        } else if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let nestedDictionary = try? container.decode([String: AnyCodable].self) {
            value = nestedDictionary
        } else if let nestedArray = try? container.decode([AnyCodable].self) {
            value = nestedArray
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to decode value")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue)
        } else if let nestedDictionary = value as? [String: AnyCodable] {
            try container.encode(nestedDictionary)
        } else if let nestedArray = value as? [AnyCodable] {
            try container.encode(nestedArray)
        } else if value == nil {
            try container.encodeNil()
        } else {
            throw EncodingError.invalidValue(value as Any, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid JSON value"))
        }
    }
}
