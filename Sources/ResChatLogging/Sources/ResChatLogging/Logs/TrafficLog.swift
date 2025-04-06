//
//  TrafficLog.swift
//  ResChatUtil
//
//  Created by Mihaela MJ on 22.09.2024..
//

import Foundation


public class TrafficLog: BaseLog {
    
    struct SocketEventKeys {
        let connect: String
        let disconnect: String
        let streamMessage: String
        let updateHistoryItem: String
        let sendHistorySnapshot: String
        
        internal init(connect: String,
                      disconnect: String,
                      streamMessage: String,
                      updateHistoryItem: String,
                      sendHistorySnapshot: String) {
            self.connect = connect
            self.disconnect = disconnect
            self.streamMessage = streamMessage
            self.updateHistoryItem = updateHistoryItem
            self.sendHistorySnapshot = sendHistorySnapshot
        }
    }
    
   // MARK: Singleton -
    
    // Singleton instance
    public static let shared = TrafficLog()
    
    // MARK: Overrides -
    
    // Specific overrides for TrafficLog
    open override var logFileName: String { "_reschat_network_log.json" }
    open override var logPrefix: String { "DBGG: Traffic->" }
    
    // MARK: Custom -
    
    let eventKeys: SocketEventKeys
    
    static let demoEventKeys: SocketEventKeys = .init(connect: "connect",
                                                      disconnect: "disconnect",
                                                      streamMessage: "stream_message",
                                                      updateHistoryItem: "update_history_item",
                                                      sendHistorySnapshot: "send_history_snapshot")
    
    // MARK: Init -
    
    init(eventKeys: SocketEventKeys = demoEventKeys) {
        self.eventKeys = eventKeys
        super.init() 
    }
}
    
// MARK: Actions -

public extension TrafficLog {
    
    func logConnect(params: [String: Any]) {
        guard Self.active else { return }
        
        let logEntry: LogEntry = [
            "event": eventKeys.connect,
            "params": params
        ]
        
        if Self.consoleActive {
            print("\(logPrefix): \(eventKeys.connect), params: `\(params)`")
        }
        
        append(logEntry)
    }
    
    func logDisconnect() {
        guard Self.active else { return }
        
        let logEntry: LogEntry = [ "event" : eventKeys.disconnect]
        
        if Self.consoleActive {
            print("\(logPrefix): \(eventKeys.disconnect)")
        }
        
        append(logEntry)
    }

    func logEmitMessage(key: String, payload: [String: Any]) {
        guard Self.active else { return }
        
        let logEntry: LogEntry = [
            "event": "emitMessage",
            "key": key,
            "payload": payload
        ]
        if Self.consoleActive {
            print("\(logPrefix): emitMessage, `\(key)`, payload: \(payload)")
        }
        append(logEntry)
    }

    func logSocketCallback(key: String, payload: [String: Any], response: [Any]) {
        guard Self.active else { return }
        
        let logEntry: LogEntry = [
            "event": "callback",
            "key": key,
            "payload": payload,
            "response": response
        ]
        
        if Self.consoleActive {
            print("\(logPrefix): callback, `\(key)`, payload: \(payload), response: \(response)")
        }
        
        append(logEntry)
    }
    
    func logOnResponse(named: String, data: [Any]) {
        guard Self.active else { return }
        
        var logEntry: LogEntry = [ "event" : "on \(named)"]
        logEntry["data"] = data
        
        if Self.consoleActive {
            print("\(logPrefix): OnResponse, `\(named)`")
            if named == eventKeys.streamMessage
                || named == eventKeys.updateHistoryItem
                || named == eventKeys.sendHistorySnapshot {
                printPrettyJSON(from: data)
            }
        }
        
        append(logEntry)
    }
}

// MARK: Helper -

public extension TrafficLog {
    static func eventName(from logEntry: TrafficLog.LogEntry) -> String? {
        if let eventName = logEntry["event"] as? String {
            return eventName
        } else {
            return nil
        }
    }
}
