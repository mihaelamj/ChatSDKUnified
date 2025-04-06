//
//  TrafficLogReplayTests.swift
//
//
//  Created by Mihaela MJ on 03.09.2024..
//

import Foundation

import XCTest
@testable import reschatSocket

class TrafficLogReplayTests: XCTestCase {
    
    func testReplay() {
        
        // load string from file
        guard let logString = XCTestCase.loadJSONFromFile(named: "_reschat_network_log") else {
            return
        }
        
        // load log
        guard let logEntries = TrafficLog.loadFromJSONString(logString) else {
            print("No log entries found.")
            return
        }
        
        // Initialize the socket
        let socket = ResChatSocket()
        
        let eventsToSkip: Set<String> = [
            ResChatSocket.SocketEventKey.disconnect.rawValue,
            // Add other events to skip as needed
        ]

        let eventReplayer = SocketEventReplayer(socket: socket, logEntries: logEntries, eventsToSkip: eventsToSkip)

        while eventReplayer.hasMore {
            eventReplayer.next()
        }
    }
}
