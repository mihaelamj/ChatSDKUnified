//
//  EventsLoadingTests.swift
//  
//
//  Created by Mihaela MJ on 02.09.2024..
//

import Foundation

import XCTest
@testable import reschatSocket

class EventsLoadingTests: XCTestCase {
    
    func debugSocketMessage(_ message: SocketMessage) {
        if let rawText = message.rawText, message.text != rawText {
            let diffs = AnyArrayParser.SanitizerType.findDifferencesBetween(message.text, rawText)
            print("--Text:--")
            print(message.text)
            print("--RawText:--")
            print(rawText)
        }
    }
    
    func testReceivedConversations() {
        let historyString = XCTestCase.TestFile.historySapshot.loadString()
        guard let historyString = historyString,
              let data = AnyArrayParser.jsonStringToArray(historyString) else {
            print("Failed to convert JSON string to array.")
            XCTFail()
            return
        }
        
        guard let conversations = AnyArrayParser.parseAndUpdateConversationsWithCleanedInput(data) else {
            print("DBGG: Error receiving Conversations data!")
            XCTFail()
            return
        }
        
        guard let messages = conversations.first?.historySnapshot.messages else {
            print("DBGG: Error receiving Conversations messages!")
            XCTFail()
            return
        }

        // Convert [HistoryMessage] to [Message]
        guard let snapshot = conversations.first?.historySnapshot else {
            print("DBGG: Error First conversation is nil!")
            XCTFail()
            return
        }
        let newMessages = snapshot.messages.map { SocketMessage(from: $0) }
        
        for message in newMessages {
            debugSocketMessage(message)
        }
        
    }
    
    func testReceivedStreamMessages() {
        let streamString = XCTestCase.TestFile.streamMessage3.loadString()
        guard let streamString = streamString,
              let data = try? JSONSerialization.jsonObject(with: Data(streamString.utf8), options: []) as? [[String: Any]] else {
            print("Failed to parse JSON string to array")
            XCTFail()
            return
        }
        
        guard let streamMessages = AnyArrayParser.parseStreamMessagesWithCleanedInput(data) else {
            print("DBGG: Error receiving Stream Message with data!")
            XCTFail()
            return
        }
        
        guard let message = streamMessages.first else {
            print("DBGG: Error First StreamMessage is nil!")
            XCTFail()
            return
        }

        let socketMessage = SocketMessage(from: message)
        debugSocketMessage(socketMessage)

    }
    
    func testReceivedUpdateHistoryItems() {
        let updateString = XCTestCase.TestFile.updateHistoryItem.loadString()
        guard let updateString = updateString,
              let data = AnyArrayParser.jsonStringToArray(updateString) else {
            print("Failed to convert JSON string to array.")
            XCTFail()
            return
        }
        
        guard let updatedMessages = AnyArrayParser.parseHistoryUpdateWithCleanedInput(data) else {
            print("DBGG: Error receiving UpdateHistoryItems with data!")
            XCTFail()
            return
        }
        
        // INFO: Get the first StreamMessage -
        guard let message = updatedMessages.first?.updatedItem else {
            print("DBGG: Error First UpdateHistoryItem is nil!")
            XCTFail()
            return
        }
        
        let socketMessage = SocketMessage(from: message)
        debugSocketMessage(socketMessage)
        
    }
}
