//
//  ParsedResponseLog.swift
//  ResChatUtil
//
//  Created by Mihaela MJ on 22.09.2024..
//

import Foundation

public class ParsedResponseLog: BaseLog {
    
    // MARK: Overrides -
    
    open override var logFileName: String { "_reschat_parsed_response_log.json" }
    open override var logPrefix: String { "DBGG: Event->" }
    
    // MARK: Singleton -

    public static let shared = ParsedResponseLog()
}

// MARK: Logging -

public extension ParsedResponseLog {

    func logEvent(name: String,
                  customParam: [String: Any]? = nil,
                  receivedMessage: DictionaryRepresentable? = nil,
                  currentMessages: [DictionaryRepresentable]? = nil,
                  receivedMessages: [DictionaryRepresentable]? = nil) {
        guard Self.active else { return }
       
        var logEntry: LogEntry = ["event" : name]
        
        // If custom parameters are provided, merge them into the log entry
        if let customParam = customParam {
            logEntry.merge(customParam) { (_, new) in new }
        }
        
        if let receivedMessage = receivedMessage {
            logEntry["receivedMessage"] = receivedMessage.toDictionary()
        }
        if let currentMessages = currentMessages {
            logEntry["currentMessages"] = currentMessages.map { $0.toDictionary() }
        }
        if let receivedMessages = receivedMessages {
            logEntry["receivedMessages"] = receivedMessages.map { $0.toDictionary() }
        }
        
        if Self.consoleActive { print("\(logPrefix): \(name)") }
        
        append(logEntry)
    }
    
    func logReceivedConversationsError(_ error: Error? = nil) {
        guard Self.active else { return }
        logError(name: "Received_Conversations", error: error)
    }
    
    func logReceivedStreamMessagesError(_ error: Error? = nil) {
        guard Self.active else { return }
        logError(name: "Received_StreamMessages", error: error)
    }
    
    func logReceivedUpdateHistoryItemsError(_ error: Error? = nil) {
        guard Self.active else { return }
        logError(name: "Received_UpdateHistoryItems", error: error)
    }
}
