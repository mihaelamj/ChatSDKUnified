//
//  UILog.swift
//  ResChatUtil
//
//  Created by Mihaela MJ on 22.09.2024..
//

import Foundation

public class UILog: BaseLog {
    
    // MARK: Overrides -
    
    open override var logFileName: String { "_reschat_UI_log.json" }
    open override var logPrefix: String { "DBGG: UI_Event->" }
    
    // MARK: Singleton -
    
    public static let shared = UILog()
}

// MARK: Logging -

public extension UILog {
    
    // Example of logging history messages
    func logHistoryMessages(receivedMessages: [DictionaryRepresentable]? = nil,
                            currentMessages: [DictionaryRepresentable]? = nil,
                            updatedMessages: [DictionaryRepresentable]? = nil) {
        guard Self.active else { return }
        
        var logEntry: LogEntry = ["event" : "HistoryMessages"]

        if let receivedMessages = receivedMessages {
            logEntry["receivedMessages"] = receivedMessages.map { $0.toDictionary() }
        }
        if let currentMessages = currentMessages {
            logEntry["currentMessages"] = currentMessages.map { $0.toDictionary() }
        }
        if let updatedMessages = updatedMessages {
            logEntry["updatedMessages"] = updatedMessages.map { $0.toDictionary() }
        }

        append(logEntry)
    }
    
    func logStreamingMessage(_ message: DictionaryRepresentable) {
        guard Self.active else { return }
        
        let logEntry: LogEntry = [
            "event": "StreamingMessage",
            "streamingMessage": message.toDictionary()
        ]
        append(logEntry)
    }
    
    func logUpdatedMessage(_ message: DictionaryRepresentable) {
        guard Self.active else { return }
        
        let logEntry: LogEntry = [
            "event": "UpdatedMessage",
            "updatedMessage": message.toDictionary()
        ]
        append(logEntry)
    }
    
    func logPlaceholderMessage(_ message: DictionaryRepresentable) {
        guard Self.active else { return }
        
        let logEntry: LogEntry = [
            "event": "LoadPlaceholderMessage",
            "PlaceholderMessage": message.toDictionary()
        ]
        append(logEntry)
    }
}
