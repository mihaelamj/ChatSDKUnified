//
//  UIMessage+DictionaryRepresentable.swift
//  ResChatUICommon
//
//  Created by Mihaela MJ on 22.09.2024..
//

import Foundation
import ResChatLogging

extension UIMessage: DictionaryRepresentable {
    public func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "text": text,
            "attributedText": attributedText.string,
            "type": type.stringValue,
            "origin": origin.rawValue,
            "messagePart": "\(messagePart)",
            "messageIndex": "\(messageIndex)",
            "isBot": "\(isBot ? "true" : "false")",
            "isPlaceholder": "\(isPlaceholder ? "true" : "false")",
            "isFinished": "\(isFinished ? "true" : "false")",
            "timestamp": timestamp,
        ]
        return dict
    }
}
