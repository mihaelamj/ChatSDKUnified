//
//  IteratorTests.swift
//  
//
//  Created by Mihaela MJ on 01.09.2024..
//

import XCTest
@testable import reschatSocket

class IteratorTests: XCTestCase {
    
    let jsonArrayString = """
    [
      {
        "message_part": 1,
        "message_id": "2024-08-27T23:54:33.506835+00:00",
        "message": {
          "thought_process": null,
          "message": {
            "surface": "chat_message",
            "render_only_for": [],
            "notification_text": null,
            "elements": [
              {
                "attachment": null,
                "html_to_markdown": false,
                "element": "text",
                "text": "0 It appears that they Voted \\"Houston's Best Burger\\" with fresh ground beef patties"
              },
              {
                "attachment": null,
                "html_to_markdown": false,
                "element": "text",
                "text": "1 Another text field."
              }
            ]
          },
          "debug_info": null,
          "sources": null
        },
        "conversation_id": null,
        "is_final": true
      }
    ]
    """
    
    func testStreamMessageIterator() {

        let jsonString = jsonArrayString
        guard var jsonArray = try? JSONSerialization.jsonObject(with: Data(jsonString.utf8), options: []) as? [[String: Any]] else {
            print("Failed to parse JSON string to array")
            XCTFail()
            return
        }

        var iterator = StreamMessageTextFieldIterator(anyArray: jsonArray)

        while let (index, text) = iterator.next() {
            print("Index: \(index), Text: \(text)")
            iterator.updateCurrentText(with: "Modified text at index \(index)+ \(Int.random(in: 0...100))")
        }

        let updatedArray = iterator.getUpdatedArray()
        print(updatedArray)
        
        
        var iteratorNew = StreamMessageTextFieldIterator(anyArray: updatedArray)
        while let (index, text) = iteratorNew.next() {
            print("Index: \(index), Text: \(text)")
            print("Done")
        }
        
        // test decode
        guard let streamMessages = AnyArrayParser.parseStreamMessages(updatedArray) else {
            fatalError("DBGG: Error receiving Stream Message with data!")
        }
        
//        print(streamMessages)
        let firstMessageText = streamMessages.first?.myMessage.text ?? "N/A"
        print(firstMessageText)
    }
    
    func testStreamMessageIterator2() {
        let jsonString = jsonArrayString
        guard var jsonArray = try? JSONSerialization.jsonObject(with: Data(jsonString.utf8), options: []) as? [[String: Any]] else {
            print("Failed to parse JSON string to array")
            XCTFail()
            return
        }
        
        guard let streamMessages = AnyArrayParser.parseStreamMessagesWithCleanedInput(jsonArray) else {
            XCTFail()
            return
        }
        
        print(streamMessages)
        let firstMessageText = streamMessages.first?.myMessage.text ?? "N/A"
        print(firstMessageText)
    }
    
    func testHistoryPayloadIterator() {
        let historyString = XCTestCase.TestFile.historySapshot.loadString()
        guard let historyString = historyString,
              let anyArray = AnyArrayParser.jsonStringToArray(historyString) else {
            print("Failed to convert JSON string to array.")
            XCTFail()
            return
        }
        
        var iterator = HistoryPayloadIterator(anyArray: anyArray)
        
        var counter = 1
        while let (index, messageIndex, text) = iterator.next() {
            print("- \(counter) Found text at index \(index), message index \(messageIndex):")
            print("- \(text)")
            counter = counter + 1
            if messageIndex > -1 {
                let updateText =  " - Updated text content \(Int.random(in: 1...20000))"
                print("-> \(updateText)")
                
                iterator.updateCurrentText(with: updateText)
            }
            print("-")
        }
        
        let updatedArray = iterator.getUpdatedArray()
        
        counter = 1
        var iteratorNew = HistoryPayloadIterator(anyArray: updatedArray)
        while let (index, messageIndex, text) = iteratorNew.next() {
            print(" - \(counter) Found text at index \(index), message index \(messageIndex)")
            print("- \(text)")
            print("-")
            counter = counter + 1
        }
        print("Done")
    }
    
    func testUpdatedHistoryPayloadIterator() {
        let historyString = XCTestCase.TestFile.updateHistoryItem.loadString()
        guard let historyString = historyString,
              let anyArray = AnyArrayParser.jsonStringToArray(historyString) else {
            print("Failed to convert JSON string to array.")
            XCTFail()
            return
        }
        
        var iterator = UpdatedItemPayloadIterator(anyArray: anyArray)
        
        var counter = 1
        while let (index, messageIndex, text) = iterator.next() {
            print("- \(counter) Found text at index \(index), message index \(messageIndex):")
            print("- \(text)")
            counter = counter + 1
            let updateText =  " - Updated text content \(Int.random(in: 1...20000))"
            print("-> \(updateText)")
            
            iterator.updateCurrentText(with: updateText)
            print("-")
        }
        
        let updatedArray = iterator.getUpdatedArray()
        
        counter = 1
        var iteratorNew = UpdatedItemPayloadIterator(anyArray: updatedArray)
        while let (index, messageIndex, text) = iteratorNew.next() {
            print(" - \(counter) Found text at index \(index), message index \(messageIndex)")
            print("- \(text)")
            print("-")
            counter = counter + 1
        }
        print("Done")
    }
}
