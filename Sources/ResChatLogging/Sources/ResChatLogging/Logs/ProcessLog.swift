//
//  ProcessLog.swift
//  ResChatUtil
//
//  Created by Mihaela MJ on 22.09.2024..
//

import Foundation

public class ProcessLog: BaseLog {
    
    // MARK: Overrides -
    
    open override var logFileName: String { "_messages_processing_log.json" }
    open override var logPrefix: String { "DBGG: ProcessLog->" }
    
    // MARK: Singleton -
    
    public static let shared = ProcessLog()
    
    // MARK: Custom -
    
    // Enum to define actions for logging
    public enum Action: String, CaseIterable {
        case processHistoryMessages
        case processStreamingMessage
        case processUpdatedMessage
    }
}

// MARK: Logging -

public extension ProcessLog {

    func log(action: Action,
             subActionName: String,
             message: DictionaryRepresentable? = nil,
             messages: [DictionaryRepresentable]? = nil) {
        guard Self.active else { return }

        var logEntry: LogEntry = ["action": action.rawValue]
        logEntry["subAction"] = subActionName
        
        // Add message to log if present
        if let message = message {
            logEntry["message"] = message.toDictionary()
        }

        // Add messages array to log if present
        if let messages = messages {
            logEntry["messages"] = messages.map { $0.toDictionary() }
        }

        // Append the log entry
        append(logEntry)
    }
}

