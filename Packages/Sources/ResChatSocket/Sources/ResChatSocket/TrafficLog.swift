//
//  TrafficLog.swift
//  
//
//  Created by Mihaela MJ on 27.08.2024..
//

import Foundation
import SocketIO
import ResChatLogging

typealias TrafficLog = ResChatLogging.TrafficLog

class SocketEventReplayer {
    
    static let logPrefix = "Replay: "

    private var logEntries: [TrafficLog.LogEntry]
    private var currentIndex: Int = -1
    private let socket: ResChatSocket
    private let eventsToSkip: Set<String>
    
    public var hasMore: Bool {
        !logEntries.isEmpty
    }

    init(socket: ResChatSocket, logEntries: [TrafficLog.LogEntry], eventsToSkip: Set<String> = []) {
        self.socket = socket
        self.logEntries = logEntries
        self.eventsToSkip = eventsToSkip
        
        print("\(Self.logPrefix): TrafficLog entries: \(logEntries.count)")
    }
    
    func next() {
        while !logEntries.isEmpty {
            currentIndex = currentIndex + 1
            let logEntry = logEntries.removeFirst()
            
            guard let event = logEntry["event"] as? String else {
                print("Invalid log entry: \(logEntry)")
                continue
            }

            if eventsToSkip.contains(event) {
                print("Skipping event: \(event)")
                continue
            }
            let eventName = TrafficLog.eventName(from: logEntry) ?? "N/A"
            print("\(Self.logPrefix): Replaying: [\(currentIndex)]: \(eventName)")
            replay(logEntry)
            break
        }
    }

    private func replay(_ logEntry: TrafficLog.LogEntry) {
        guard let event = logEntry["event"] as? String else {
            print("Invalid log entry: \(logEntry)")
            return
        }
        let cleanEventName: String = {
            if event.hasPrefix("on ") {
                return String(event.dropFirst(3))
            } else {
                return event
            }
        }()
        
        switch cleanEventName {
        case ResChatSocket.SocketEventKey.connect.rawValue:
            if let data = logEntry["data"] as? [Any] {
                socket.onConnect(data: data)
            }
        case ResChatSocket.SocketEventKey.disconnect.rawValue:
            if let data = logEntry["data"] as? [Any] {
                socket.onDisconnect(data: data)
            }
        case ResChatSocket.SocketEventKey.error.rawValue:
            if let data = logEntry["data"] as? [Any] {
                socket.onError(data: data)
            }
        case ResChatSocket.SocketEventKey.sendHistorySnapshot.rawValue:
            if let data = logEntry["data"] as? [Any] {
                socket.handleReceivedConversations(data: data)
            }
        case ResChatSocket.SocketEventKey.streamMessage.rawValue:
            if let data = logEntry["data"] as? [Any] {
                socket.handleReceivedStreamMessages(data: data)
            }
        case ResChatSocket.SocketEventKey.updateHistoryItem.rawValue:
            if let data = logEntry["data"] as? [Any] {
                socket.handleReceivedUpdateHistoryItems(data: data)
            }
        default:
            print("Unknown event: \(event)")
        }
    }
}

/**
 let eventsToSkip: Set<String> = [
     ResChatSocket.SocketEventKey.disconnect.rawValue,
     // Add other events to skip as needed
 ]

 let eventReplayer = SocketEventReplayer(socket: socket, logEntries: logEntries, eventsToSkip: eventsToSkip)

 while eventReplayer.currentIndex < logEntries.count {
     eventReplayer.next()
 }
 */
