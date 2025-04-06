//
//  HistoryUpdatedMessageTests.swift
//  
//
//  Created by Mihaela MJ on 31.08.2024..
//

import XCTest
@testable import reschatSocket

class HistoryUpdatedMessageTests: XCTestCase {
    
    let jsonString1 = """
    {
        "origin": "bot",
        "update_timestamp": "2024-08-27T23:06:04.074785+00:00",
        "payload_type": "message",
        "request_id": null,
        "feedback_explanation": null,
        "payload": "{\\"message\\": {\\"elements\\": [{\\"element\\": \\"text\\", \\"text\\": \\"It appears that there isn't a KFC at George Bush Intercontinental Airport (IAH). However, there are many other dining options available. If you have a specific type of cuisine or another restaurant in mind, feel free to let me know, and I can help you find something that suits your taste!\\", \\"html_to_markdown\\": false, \\"attachment\\": null}], \\"surface\\": \\"chat_message\\", \\"render_only_for\\": [], \\"notification_text\\": null}, \\"sources\\": null, \\"thought_process\\": null, \\"debug_info\\": null}",
        "timestamp": "2024-08-27T23:06:03.147342+00:00",
        "metadata": null,
        "feedback_type": null
    }
    """
    
    let jsonString2 = """
    {
      "conversation_id": null,
      "updated_item": {
        "origin": "bot",
        "update_timestamp": "2024-08-27T23:54:33.768145+00:00",
        "payload_type": "message",
        "request_id": null,
        "feedback_explanation": null,
        "payload": "{\"message\": {\"elements\": [{\"element\": \"text\", \"text\": \"\", \"html_to_markdown\": false, \"attachment\": null}], \"surface\": \"chat_message\", \"render_only_for\": [], \"notification_text\": null}, \"sources\": null, \"thought_process\": null, \"debug_info\": null}",
        "timestamp": "2024-08-27T23:54:33.506835+00:00",
        "metadata": null,
        "feedback_type": null
      }
    }
    """
    
    let jsonString3 = """
    {
      "conversation_id": null,
      "updated_item": {
        "origin": "bot",
        "update_timestamp": "2024-08-27T23:55:04.794292+00:00",
        "payload_type": "message",
        "request_id": null,
        "feedback_explanation": null,
        "payload": "{\"message\": {\"elements\": [{\"element\": \"text\", \"text\": \"\", \"html_to_markdown\": false, \"attachment\": null}], \"surface\": \"chat_message\", \"render_only_for\": [], \"notification_text\": null}, \"sources\": null, \"thought_process\": null, \"debug_info\": null}",
        "timestamp": "2024-08-27T23:55:04.570135+00:00",
        "metadata": null,
        "feedback_type": null
      }
    }
    """
    
    func testHistoryUpdatedMessageDecoding() throws {
        // The JSON string to decode
        let jsonString = jsonString1
        guard let updatedMessage = StringParser.parseHistoryUpdatedMessageFromString(jsonString) else {
            fatalError("Error decodingu pdatedMessage")
        }
        let messageData = updatedMessage.myMessage
        XCTAssertNil(messageData)
        print(messageData)
    }
    
    func testHistoryUpdatedMessageDecoding1() throws {


        let jsonString = jsonString1
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()

        let historyUpdatedMessage = try decoder.decode(HistoryUpdatedMessage.self, from: jsonData)
        
        // Assert common fields
        XCTAssertEqual(historyUpdatedMessage.common.origin, "bot")
        XCTAssertEqual(historyUpdatedMessage.common.timestamp, "2024-08-27T23:06:03.147342+00:00")
        XCTAssertEqual(historyUpdatedMessage.common.payloadType, "message")
        
        // Assert specific fields
        XCTAssertEqual(historyUpdatedMessage.updateTimestamp, "2024-08-27T23:06:04.074785+00:00")
        
        // Assert decoded message data
        XCTAssertEqual(historyUpdatedMessage.myMessage.text, "It appears that there isn't a KFC at George Bush Intercontinental Airport (IAH). However, there are many other dining options available. If you have a specific type of cuisine or another restaurant in mind, feel free to let me know, and I can help you find something that suits your taste!")
    }
    
    func testHistoryUpdatedMarkdownMessageDecoding() throws {
        // The JSON string to decode
        let jsonString = """
        {
            "origin": "bot",
            "update_timestamp": "2024-08-27T23:06:04.074785+00:00",
            "payload_type": "message",
            "request_id": null,
            "feedback_explanation": null,
            "payload": "{\\"message\\": {\\"elements\\": [{\\"element\\": \\"text\\", \\"text\\": \\"It appears that there isn't a KFC at George Bush Intercontinental Airport (IAH). However, there are many other dining options available. If you have a specific type of cuisine or another restaurant in mind, feel free to let me know, and I can help you find something that suits your taste!\\", \\"html_to_markdown\\": false, \\"attachment\\": null}], \\"surface\\": \\"chat_message\\", \\"render_only_for\\": [], \\"notification_text\\": null}, \\"sources\\": null, \\"thought_process\\": null, \\"debug_info\\": null}",
            "timestamp": "2024-08-27T23:06:03.147342+00:00",
            "metadata": null,
            "feedback_type": null
        }
        """

        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let historyUpdatedMessage = try decoder.decode(HistoryUpdatedMessage.self, from: jsonData)
        
        // Assert common fields
        XCTAssertEqual(historyUpdatedMessage.common.origin, "bot")
        XCTAssertEqual(historyUpdatedMessage.common.timestamp, "2024-08-27T23:06:03.147342+00:00")
        XCTAssertEqual(historyUpdatedMessage.common.payloadType, "message")
        
        // Assert specific fields
        XCTAssertEqual(historyUpdatedMessage.updateTimestamp, "2024-08-27T23:06:04.074785+00:00")
        
        // Assert decoded message data
        XCTAssertEqual(historyUpdatedMessage.myMessage.text, "It appears that there isn't a KFC at George Bush Intercontinental Airport (IAH). However, there are many other dining options available. If you have a specific type of cuisine or another restaurant in mind, feel free to let me know, and I can help you find something that suits your taste!")
    }
}
