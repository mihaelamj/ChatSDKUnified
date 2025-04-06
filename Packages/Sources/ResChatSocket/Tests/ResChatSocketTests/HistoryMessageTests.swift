//
//  HistoryMessageTests.swift
//  
//
//  Created by Mihaela MJ on 31.08.2024..
//

import XCTest
@testable import reschatSocket

class HistoryMessageTests: XCTestCase {
    
    let jsonString1 = """
    {
      "origin": "bot",
      "feedback_type": null,
      "payload_type": "message",
      "request_id": "3732471eb389438c9f34c20df8179981",
      "feedback_explanation": null,
      "payload": "{\"message\": {\"elements\": [{\"element\": \"text\", \"text\": \"It looks like there isn't a McDonald's at George Bush Intercontinental Airport (IAH). However, there are plenty of other dining options available. Here are a few you might find interesting:\\n\\n1. **The Line Sports Grill**\\n   - **Description:** Elevated sports bar and grill with quality, fresh ingredients.\\n   - **Location:** Terminal B Level 2\\n   - **Hours:** Mo-Su 06:00-21:00\\n   - [Directions](https://maps.google.com/?q=29.985953,-95.345823)\\n   - ![The Line Sports Grill](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/c181712e-d84b-460b-b8f7-0a8c25075cf2)\\n\\n2. **Pappadeaux Seafood Kitchen**\\n   - **Description:** Fresh seafood, large salads, flavorful pastas, and homemade desserts.\\n   - **Location:** Terminal E Level 2\\n   - **Hours:** Mo-Su 11:00-19:30\\n   - [Directions](https://maps.google.com/?q=29.984669,-95.335287)\\n   - ![Pappadeaux Seafood Kitchen](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/Pappadaeux2-E-IAH.jpg)\\n   - [Menu](https://files.pappadeaux.com/images/dyn/menus/menu_2965.pdf)\\n\\n3. **Hubcap Grill & Beer Yard**\\n   - **Description:** Voted \\\"Houston's Best Burger\\\" with fresh ground beef patties and locally baked buns.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Su 05:00-20:00\\n   - [Directions](https://maps.google.com/?q=29.98579,-95.350982)\\n   - ![Hubcap Grill & Beer Yard](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Hubcap%20Grill.jpg)\\n   - [Menu](http://hubcapgrill.com/index.html)\\n\\n4. **The Breakfast Klub**\\n   - **Description:** Family-style restaurant with a soulful atmosphere.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Fr 04:30-20:30; Su 04:30-20:30; Sa 04:30-19:30\\n   - [Directions](https://maps.google.com/?q=29.987977,-95.34996)\\n   - ![The Breakfast Klub](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-The%20Breakfast%20Klub-003-TANF-4-1706.jpg)\\n   - [Menu](http://thebreakfastklub.com/)\\n\\nI hope you find something delicious to enjoy!\\n\\n\", \"html_to_markdown\": false, \"attachment\": null}], \"surface\": \"chat_message\", \"render_only_for\": [], \"notification_text\": null}, \"sources\": \"search_services on pages 1-1\", \"thought_process\": null, \"debug_info\": null}",
      "session": {
        "session_id": "efda9a55-17aa-4909-8bdc-3f9751f17a75",
        "active": true,
        "session_name": "Session 1",
        "created_timestamp": "2024-08-20T22:20:19.543217+00:00",
        "agent_id": null
      },
      "timestamp": "2024-08-21T15:59:41.566304+00:00",
      "metadata": null,
      "index": 4
    }
    """
    
    func testHistoryMessageDecoding() throws {
        // The JSON string to decode
        let jsonString = """
        {
            "origin": "bot",
            "feedback_type": null,
            "payload_type": "message",
            "request_id": "c07f155e3c2e4e9ab2251f6556014a7e",
            "feedback_explanation": null,
            "payload": "{\\"message\\": {\\"elements\\": [{\\"element\\": \\"text\\", \\"text\\": \\"It appears that there isn't a KFC at George Bush Intercontinental Airport (IAH). However, there are many other dining options available. If you have a specific type of cuisine or another restaurant in mind, feel free to let me know, and I can help you find something that suits your taste!\\", \\"html_to_markdown\\": false, \\"attachment\\": null}], \\"surface\\": \\"chat_message\\", \\"render_only_for\\": [], \\"notification_text\\": null}, \\"sources\\": null, \\"thought_process\\": null, \\"debug_info\\": null}",
            "session": {
                "session_id": "efda9a55-17aa-4909-8bdc-3f9751f17a75",
                "active": true,
                "session_name": "Session 1",
                "created_timestamp": "2024-08-20T22:20:19.543217+00:00",
                "agent_id": null
            },
            "timestamp": "2024-08-27T23:06:03.147342+00:00",
            "metadata": null,
            "index": 12
        }
        """

        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let historyMessage = try decoder.decode(HistoryMessage.self, from: jsonData)
        
        // Assert common fields
        XCTAssertEqual(historyMessage.common.origin, "bot")
        XCTAssertEqual(historyMessage.common.timestamp, "2024-08-27T23:06:03.147342+00:00")
        XCTAssertEqual(historyMessage.common.payloadType, "message")
        
        // Assert specific fields
        XCTAssertEqual(historyMessage.index, 12)
        XCTAssertEqual(historyMessage.session.sessionId, "efda9a55-17aa-4909-8bdc-3f9751f17a75")
        
        let messageData = historyMessage.myMessage
        
        // Assert decoded message data
        XCTAssertEqual(messageData.text, "It appears that there isn't a KFC at George Bush Intercontinental Airport (IAH). However, there are many other dining options available. If you have a specific type of cuisine or another restaurant in mind, feel free to let me know, and I can help you find something that suits your taste!")
    }
}

extension HistoryMessageTests {
    func testHistoryMarkdownMessageDecoding() throws {
        // The JSON string to decode
        let jsonString = """
        {
            "origin": "bot",
            "feedback_type": null,
            "payload_type": "message",
            "request_id": "3732471eb389438c9f34c20df8179981",
            "feedback_explanation": null,
            "payload": "{\\"message\\": {\\"elements\\": [{\\"element\\": \\"text\\", \\"text\\": \\"It looks like there isn't a McDonald's at George Bush Intercontinental Airport (IAH). However, there are plenty of other dining options available. Here are a few you might find interesting:\\n\\n1. **The Line Sports Grill**\\n   - **Description:** Elevated sports bar and grill with quality, fresh ingredients.\\n   - **Location:** Terminal B Level 2\\n   - **Hours:** Mo-Su 06:00-21:00\\n   - [Directions](https://maps.google.com/?q=29.985953,-95.345823)\\n   - ![The Line Sports Grill](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/c181712e-d84b-460b-b8f7-0a8c25075cf2)\\n\\n2. **Pappadeaux Seafood Kitchen**\\n   - **Description:** Fresh seafood, large salads, flavorful pastas, and homemade desserts.\\n   - **Location:** Terminal E Level 2\\n   - **Hours:** Mo-Su 11:00-19:30\\n   - [Directions](https://maps.google.com/?q=29.984669,-95.335287)\\n   - ![Pappadeaux Seafood Kitchen](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/Pappadaeux2-E-IAH.jpg)\\n   - [Menu](https://files.pappadeaux.com/images/dyn/menus/menu_2965.pdf)\\n\\n3. **Hubcap Grill & Beer Yard**\\n   - **Description:** Voted \\\\"Houston's Best Burger\\\\\\" with fresh ground beef patties and locally baked buns.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Su 05:00-20:00\\n   - [Directions](https://maps.google.com/?q=29.98579,-95.350982)\\n   - ![Hubcap Grill & Beer Yard](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Hubcap%20Grill.jpg)\\n   - [Menu](http://hubcapgrill.com/index.html)\\n\\n4. **The Breakfast Klub**\\n   - **Description:** Family-style restaurant with a soulful atmosphere.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Fr 04:30-20:30; Su 04:30-20:30; Sa 04:30-19:30\\n   - [Directions](https://maps.google.com/?q=29.987977,-95.34996)\\n   - ![The Breakfast Klub](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-The%20Breakfast%20Klub-003-TANF-4-1706.jpg)\\n   - [Menu](http://thebreakfastklub.com/)\\n\\nI hope you find something delicious to enjoy!\\n\\n\\", \\"html_to_markdown\\": false, \\"attachment\\": null}], \\"surface\\": \\"chat_message\\", \\"render_only_for\\": [], \\"notification_text\\": null}, \\"sources\\": \\"search_services on pages 1-1\\", \\"thought_process\\": null, \\"debug_info\\": null}",
            "session": {
                "session_id": "efda9a55-17aa-4909-8bdc-3f9751f17a75",
                "active": true,
                "session_name": "Session 1",
                "created_timestamp": "2024-08-20T22:20:19.543217+00:00",
                "agent_id": null
            },
            "timestamp": "2024-08-21T15:59:41.566304+00:00",
            "metadata": null,
            "index": 4
        }
        """

        let unfucketString = jsonString
        // Convert JSON string to Data
        let jsonData = unfucketString.data(using: .utf8)!
        
        // Decode JSON into a HistoryMessage object
        let decoder = JSONDecoder()
        let historyMessage = try decoder.decode(HistoryMessage.self, from: jsonData)
        
        // Assert common fields
        XCTAssertEqual(historyMessage.common.origin, "bot")
        XCTAssertEqual(historyMessage.common.timestamp, "2024-08-21T15:59:41.566304+00:00")
        XCTAssertEqual(historyMessage.common.payloadType, "message")
        
        // Assert specific fields
        XCTAssertEqual(historyMessage.index, 4)
        XCTAssertEqual(historyMessage.session.sessionId, "efda9a55-17aa-4909-8bdc-3f9751f17a75")
        
        let messageData = historyMessage.myMessage

        
        // Assert decoded message data
        XCTAssertEqual(messageData.text, """
            It looks like there isn't a McDonald's at George Bush Intercontinental Airport (IAH). However, there are plenty of other dining options available. Here are a few you might find interesting:

            1. **The Line Sports Grill**
               - **Description:** Elevated sports bar and grill with quality, fresh ingredients.
               - **Location:** Terminal B Level 2
               - **Hours:** Mo-Su 06:00-21:00
               - [Directions](https://maps.google.com/?q=29.985953,-95.345823)
               - ![The Line Sports Grill](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/c181712e-d84b-460b-b8f7-0a8c25075cf2)

            2. **Pappadeaux Seafood Kitchen**
               - **Description:** Fresh seafood, large salads, flavorful pastas, and homemade desserts.
               - **Location:** Terminal E Level 2
               - **Hours:** Mo-Su 11:00-19:30
               - [Directions](https://maps.google.com/?q=29.984669,-95.335287)
               - ![Pappadeaux Seafood Kitchen](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/Pappadaeux2-E-IAH.jpg)
               - [Menu](https://files.pappadeaux.com/images/dyn/menus/menu_2965.pdf)

            3. **Hubcap Grill & Beer Yard**
               - **Description:** Voted \"Houston's Best Burger\" with fresh ground beef patties and locally baked buns.
               - **Location:** Terminal A Level 2
               - **Hours:** Mo-Su 05:00-20:00
               - [Directions](https://maps.google.com/?q=29.98579,-95.350982)
               - ![Hubcap Grill & Beer Yard](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Hubcap%20Grill.jpg)
               - [Menu](http://hubcapgrill.com/index.html)

            4. **The Breakfast Klub**
               - **Description:** Family-style restaurant with a soulful atmosphere.
               - **Location:** Terminal A Level 2
               - **Hours:** Mo-Fr 04:30-20:30; Su 04:30-20:30; Sa 04:30-19:30
               - [Directions](https://maps.google.com/?q=29.987977,-95.34996)
               - ![The Breakfast Klub](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-The%20Breakfast%20Klub-003-TANF-4-1706.jpg)
               - [Menu](http://thebreakfastklub.com/)

            I hope you find something delicious to enjoy!

            """)
    }
}


/**
 {
   "origin": "bot",
   "feedback_type": null,
   "payload_type": "message",
   "request_id": "3732471eb389438c9f34c20df8179981",
   "feedback_explanation": null,
   "payload": "{\"message\": {\"elements\": [{\"element\": \"text\", \"text\": \"It looks like there isn't a McDonald's at George Bush Intercontinental Airport (IAH). However, there are plenty of other dining options available. Here are a few you might find interesting:\\n\\n1. **The Line Sports Grill**\\n   - **Description:** Elevated sports bar and grill with quality, fresh ingredients.\\n   - **Location:** Terminal B Level 2\\n   - **Hours:** Mo-Su 06:00-21:00\\n   - [Directions](https://maps.google.com/?q=29.985953,-95.345823)\\n   - ![The Line Sports Grill](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/c181712e-d84b-460b-b8f7-0a8c25075cf2)\\n\\n2. **Pappadeaux Seafood Kitchen**\\n   - **Description:** Fresh seafood, large salads, flavorful pastas, and homemade desserts.\\n   - **Location:** Terminal E Level 2\\n   - **Hours:** Mo-Su 11:00-19:30\\n   - [Directions](https://maps.google.com/?q=29.984669,-95.335287)\\n   - ![Pappadeaux Seafood Kitchen](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/Pappadaeux2-E-IAH.jpg)\\n   - [Menu](https://files.pappadeaux.com/images/dyn/menus/menu_2965.pdf)\\n\\n3. **Hubcap Grill & Beer Yard**\\n   - **Description:** Voted \\\"Houston's Best Burger\\\" with fresh ground beef patties and locally baked buns.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Su 05:00-20:00\\n   - [Directions](https://maps.google.com/?q=29.98579,-95.350982)\\n   - ![Hubcap Grill & Beer Yard](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Hubcap%20Grill.jpg)\\n   - [Menu](http://hubcapgrill.com/index.html)\\n\\n4. **The Breakfast Klub**\\n   - **Description:** Family-style restaurant with a soulful atmosphere.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Fr 04:30-20:30; Su 04:30-20:30; Sa 04:30-19:30\\n   - [Directions](https://maps.google.com/?q=29.987977,-95.34996)\\n   - ![The Breakfast Klub](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-The%20Breakfast%20Klub-003-TANF-4-1706.jpg)\\n   - [Menu](http://thebreakfastklub.com/)\\n\\nI hope you find something delicious to enjoy!\\n\\n\", \"html_to_markdown\": false, \"attachment\": null}], \"surface\": \"chat_message\", \"render_only_for\": [], \"notification_text\": null}, \"sources\": \"search_services on pages 1-1\", \"thought_process\": null, \"debug_info\": null}",
   "session": {
     "session_id": "efda9a55-17aa-4909-8bdc-3f9751f17a75",
     "active": true,
     "session_name": "Session 1",
     "created_timestamp": "2024-08-20T22:20:19.543217+00:00",
     "agent_id": null
   },
   "timestamp": "2024-08-21T15:59:41.566304+00:00",
   "metadata": null,
   "index": 4
 }
 */

