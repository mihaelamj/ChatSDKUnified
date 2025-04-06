//
//  DictionaryRepresentable.swift
//  ResChatUtil
//
//  Created by Mihaela MJ on 22.09.2024..
//

import Foundation

public protocol DictionaryRepresentable {
    func toDictionary() -> [String: Any]
}

public extension DictionaryRepresentable {
    func toDictionary(baseFields: [String: Any], additionalFields: [String: Any] = [:]) -> [String: Any] {
        return baseFields.merging(additionalFields) { (current, _) in current }
    }
}
