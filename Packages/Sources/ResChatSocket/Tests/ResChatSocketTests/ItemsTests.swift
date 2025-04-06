//
//  ItemsTests.swift
//
//
//  Created by Mihaela MJ on 01.09.2024..
//

import XCTest
@testable import reschatSocket

class ItemsTests: XCTestCase {
    
    func testDecodingConversations() {
        guard let jsonString = XCTestCase.TestFile.historySapshot.loadString() else {
            XCTFail("Error loading: \(XCTestCase.TestFile.historySapshot)")
            fatalError()
        }
        
        guard let result = StringParser.parseConversationsFromString(jsonString) else {
            XCTFail("Error parsing Conversations from string")
            return
        }
        
        print(result)
        
        // Inspect payload
        
        guard let messages = result.first?.historySnapshot.messages else {
            XCTFail("Error getting messages from Conversations")
            return
        }
        
        for message in messages {
            let messageData = message.myMessage
        }
        
    }
    
    func testDecodingStreamMessages1() {
        guard let jsonString = XCTestCase.TestFile.streamMessage1.loadString() else {
            XCTFail("Error loading: \(XCTestCase.TestFile.streamMessage1)")
            fatalError()
        }
        
        guard let result = StringParser.parseStreamMessagessFromString(jsonString) else {
            XCTFail("Error parsing Stream Messagess 1 from string")
            return
        }
        
        print(result)
        
        // Inspect message
        
        guard let message = result.first?.message else {
            XCTFail("Error getting message from StreamMessage")
            return
        }
    }
    
    func testDecodingStreamMessages2() {
        guard let jsonString = XCTestCase.TestFile.streamMessage2.loadString() else {
            XCTFail("Error loading: \(XCTestCase.TestFile.streamMessage2)")
            fatalError()
        }
        
        guard let result = StringParser.parseStreamMessagessFromString(jsonString) else {
            XCTFail("Error parsing Stream Messagess 2 from string")
            return
        }
        
        print(result)
    }
    
    func testDecodingUpdateHistoryItems() {
        guard let jsonString = XCTestCase.TestFile.updateHistoryItem.loadString() else {
            XCTFail("Error loading: \(XCTestCase.TestFile.updateHistoryItem)")
            fatalError()
        }
        
        guard let result = StringParser.parseHistoryUpdateItemsFromString(jsonString) else {
            XCTFail("Error parsing History Update Items from string")
            return
        }
        
        print(result)
            
            
    }
}
