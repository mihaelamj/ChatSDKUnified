//
//  SocketMessage+DictionaryRepresentable.swift
//  reschatSocket
//
//  Created by Mihaela MJ on 22.09.2024..
//

import Foundation
import ResChatLogging

extension SocketMessage: DictionaryRepresentable {
    public func toDictionary() -> [String: Any] {
        let _rawText = rawText ?? "-"
        let dict: [String: Any] = [
            "text": text,
            "rawText": _rawText,
            "socketSource": socketSource.rawValue,
            "messagePartNumber": "\(messagePartNumber)",
            "messageIndex": "\(messageIndex)",
            "isBot": "\(isBotMessage ? "true" : "false")",
            "isMessageFinished": "\(isMessageFinished ? "true" : "false")",
            "timestamp": messageTimestamp,
        ]
        return dict
    }
}
