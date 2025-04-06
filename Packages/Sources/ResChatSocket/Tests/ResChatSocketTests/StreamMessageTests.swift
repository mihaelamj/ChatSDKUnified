//
//  StreamMessageTests.swift
//
//
//  Created by Mihaela MJ on 01.08.2024..
//

import XCTest
@testable import reschatSocket

class StreamMessageTests: XCTestCase {
    
    let fullStreamMessage = """
    {
      "message_part": 1243,
      "message_id": "2024-08-27T23:55:04.570135+00:00",
      "message": {
        "thought_process": null,
        "message": {
          "surface": "chat_message",
          "render_only_for": [
          ],
          "notification_text": null,
          "elements": [
            {
              "attachment": null,
              "html_to_markdown": false,
              "element": "text",
              "text": "Here are some great restaurant options at George Bush Intercontinental Airport (IAH):\n\n1. **The Line Sports Grill**\n   - **Description:** Elevated sports bar and grill with quality, fresh ingredients.\n   - **Location:** Terminal B Level 2\n   - **Hours:** Mo-Su 06:00-21:00\n   - [Directions](https://maps.google.com/?q=29.985953,-95.345823)\n   - ![The Line Sports Grill](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/c181712e-d84b-460b-b8f7-0a8c25075cf2)\n\n2. **Sugarland Beer Garden**\n   - **Description:** Traditional beer garden with bottled and tap beers, fresh salads, handmade pretzels, and sausages.\n   - **Location:** Terminal B Level 2\n   - **Hours:** Mo-Su 08:00-22:00\n   - [Directions](https://maps.google.com/?q=29.985585,-95.345959)\n   - ![Sugarland Beer Garden](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/12_IMG_3614.jpg)\n\n3. **Q Bar**\n   - **Description:** Texas barbeque staples such as brisket, ribs, and sausage.\n   - **Location:** Terminal B Level 2\n   - **Hours:** Mo-Su 06:00-21:00\n   - [Directions](https://maps.google.com/?q=29.985582,-95.345402)\n   - ![Q Bar](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/has--5.jpg)\n\n4. **Pappadeaux Seafood Kitchen**\n   - **Description:** Fresh seafood, large salads, flavorful pastas, and homemade desserts.\n   - **Location:** Terminal E Level 2\n   - **Hours:** Mo-Su 11:00-19:30\n   - [Directions](https://maps.google.com/?q=29.984669,-95.335287)\n   - ![Pappadeaux Seafood Kitchen](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/Pappadaeux2-E-IAH.jpg)\n   - [Menu](https://files.pappadeaux.com/images/dyn/menus/menu_2965.pdf)\n\n5. **Hubcap Grill & Beer Yard**\n   - **Description:** Voted \"Houston's Best Burger\" with fresh ground beef patties and locally baked buns.\n   - **Location:** Terminal A Level 2\n   - **Hours:** Mo-Su 05:00-20:00\n   - [Directions](https://maps.google.com/?q=29.98579,-95.350982)\n   - ![Hubcap Grill & Beer Yard](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Hubcap%20Grill.jpg)\n   - [Menu](http://hubcapgrill.com/index.html)\n\n6. **The Breakfast Klub**\n   - **Description:** Family-style restaurant with a soulful atmosphere.\n   - **Location:** Terminal A Level 2\n   - **Hours:** Mo-Fr 04:30-20:30; Su 04:30-20:30; Sa 04:30-19:30\n   - [Directions](https://maps.google.com/?q=29.987977,-95.34996)\n   - ![The Breakfast Klub](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-The%20Breakfast%20Klub-003-TANF-4-1706.jpg)\n   - [Menu](http://thebreakfastklub.com/)\n\n7. **Cadillac Mexican Kitchen & Tequila Bar**\n   - **Description:** Authentic Mexican food with a lively atmosphere.\n   - **Location:** Terminal A Level 2\n   - **Hours:** Mo-Su 07:00-22:00\n   - [Directions](https://maps.google.com/?q=29.985382,-95.350014)\n   - ![Cadillac Mexican Kitchen & Tequila Bar](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Cadillac%20Mexican%20Kitchen.jpg)\n   - [Menu](https://d14ik00wldmhq.cloudfront.net/media/filer_public/94/a5/94a553e1-a899-4095-ad1c-51c4d4d9020c/iah-dine-menu-cadillac-mexican-kitchen-and-tequilla-bartasf-5-rev-171016-gate-a15-180504.pdf)\n\n8. **Landry's Seafood**\n   - **Description:** Gulf Coast cuisine with sensational steaks, seafood, and pasta specialties.\n   - **Location:** Terminal C Level 2\n   - **Hours:** Mo-Fr 08:00-19:00; Su 08:00-19:00; Sa 12:00-17:00\n   - [Directions](https://maps.google.com/?q=29.985391,-95.338317)\n   - ![Landry's Seafood](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Landry's%20Seafood-003-TCSF-3-1706.jpg)\n   - [Menu](https://fly"
            }
          ]
        },
        "debug_info": null,
        "sources": null
      },
      "conversation_id": null,
      "is_final": false
    }
    """
    
    let smallStreamMessage = """
    {
      "message_part": 63,
      "message_id": "2024-08-27T23:06:03.147342+00:00",
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
              "text": "It appears that there isn't a KFC at George Bush Intercontinental Airport (IAH). However, there are many other dining options available. If you have a specific type of cuisine or another restaurant in mind, feel free to let me know, and I can help you find something that suits your taste!"
            }
          ]
        },
        "debug_info": null,
        "sources": null
      },
      "conversation_id": null,
      "is_final": true
    }
    """
    
    /**
     
     */
    
    func testStreamMessageDecodingTest() throws {
        let jsonString = """
    {
      "message_part": 63,
      "message_id": "2024-08-27T23:06:03.147342+00:00",
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
              "text": "It appears that they Voted \"Houston's Best Burger\" with fresh ground beef patties"
            }
          ]
        },
        "debug_info": null,
        "sources": null
      },
      "conversation_id": null,
      "is_final": true
    }
    """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        do {
            let streamMessage = try decoder.decode(StreamMessage.self, from: jsonData)
            
            // Assert specific fields
            XCTAssertEqual(streamMessage.messagePart, 63)
            XCTAssertEqual(streamMessage.messageId, "2024-08-27T23:06:03.147342+00:00")
            XCTAssertEqual(streamMessage.isFinal, true)
            
            let message = streamMessage.myMessage
            
        } catch let DecodingError.dataCorrupted(context) {
            // Handle specific decoding error with context
            print("DBGG: Error decoding MessagePayload: \(context.debugDescription)")
            if let underlyingError = context.underlyingError as NSError? {
                ErrorHelper.handleDecodingError(error: underlyingError, in: jsonString)
            }
            XCTFail()
        } catch let error as NSError {
            // Handle other decoding errors
            ErrorHelper.handleDecodingError(error: error, in: jsonString)
            XCTFail()
        }

        
//        let streamMessage = try decoder.decode(StreamMessage.self, from: jsonData)
//        
//        // Assert specific fields
//        XCTAssertEqual(streamMessage.messagePart, 63)
//        XCTAssertEqual(streamMessage.messageId, "2024-08-27T23:06:03.147342+00:00")
//        XCTAssertEqual(streamMessage.isFinal, true)
//        
//        // Assert decoded message data
//        XCTAssertEqual(streamMessage.messageData.text, "It appears that there isn't a KFC at George Bush Intercontinental Airport (IAH). However, there are many other dining options available. If you have a specific type of cuisine or another restaurant in mind, feel free to let me know, and I can help you find something that suits your taste!")
    }
    
    func testStreamMessageDecoding() throws {
        let jsonString = smallStreamMessage
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let streamMessage = try decoder.decode(StreamMessage.self, from: jsonData)
        
        // Assert specific fields
        XCTAssertEqual(streamMessage.messagePart, 63)
        XCTAssertEqual(streamMessage.messageId, "2024-08-27T23:06:03.147342+00:00")
        XCTAssertEqual(streamMessage.isFinal, true)
        
        // Assert decoded message data
        XCTAssertEqual(streamMessage.myMessage.text, "It appears that there isn't a KFC at George Bush Intercontinental Airport (IAH). However, there are many other dining options available. If you have a specific type of cuisine or another restaurant in mind, feel free to let me know, and I can help you find something that suits your taste!")
    }
    
    func testStreamMessageMarkdownDecoding() throws {
        let jsonString = fullStreamMessage
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let streamMessage = try decoder.decode(StreamMessage.self, from: jsonData)
        
        // Assert specific fields
        XCTAssertEqual(streamMessage.messagePart, 1251)
        XCTAssertEqual(streamMessage.messageId, "2024-08-27T23:55:04.570135+00:00")
        XCTAssertEqual(streamMessage.isFinal, false)

    }
    
    /**
     A1S5SQXXRCG0RC/351x197cc
     */
    
    
    func testDecodingStreamMessageOld() {
        let jsonData = """
        [
            {
                "conversation_id": "conv456",
                "is_final": 0,
                "message": {
                    "debug_info": null,
                    "message": {
                        "elements": [
                            {
                                "attachment": null,
                                "element": "text",
                                "html_to_markdown": 0,
                                "text": "Of course! I'm here to assist you. What do you need help with?"
                            }
                        ],
                        "notification_text": null,
                        "render_only_for": [],
                        "surface": "chat_message"
                    },
                    "sources": null,
                    "thought_process": null
                },
                "message_id": "2024-08-01T16:34:25.151602+00:00",
                "message_part": 18
            }
        ]
        """.data(using: .utf8)!

        do {
            let streamMessages = try JSONDecoder().decode([StreamMessage].self, from: jsonData)
            print(streamMessages)
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
    func testStreamMessageMarkdownDecoding1() throws {
        let myString = """
        {
          "message_part": 1243,
          "message_id": "2024-08-27T23:55:04.570135+00:00",
          "message": {
            "thought_process": null,
            "message": {
              "surface": "chat_message",
              "render_only_for": [
              ],
              "notification_text": null,
              "elements": [
                {
                  "attachment": null,
                  "html_to_markdown": false,
                  "element": "text",
                  "text": "Here are some great restaurant options at George Bush Intercontinental Airport (IAH):\n\n1. **The Line Sports Grill**\n   - **Description:** Elevated sports bar and grill with quality, fresh ingredients.\n   - **Location:** Terminal B Level 2\n   - **Hours:** Mo-Su 06:00-21:00\n   - [Directions](https://maps.google.com/?q=29.985953,-95.345823)\n   - ![The Line Sports Grill](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/c181712e-d84b-460b-b8f7-0a8c25075cf2)\n\n2. **Sugarland Beer Garden**\n   - **Description:** Traditional beer garden with bottled and tap beers, fresh salads, handmade pretzels, and sausages.\n   - **Location:** Terminal B Level 2\n   - **Hours:** Mo-Su 08:00-22:00\n   - [Directions](https://maps.google.com/?q=29.985585,-95.345959)\n   - ![Sugarland Beer Garden](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/12_IMG_3614.jpg)\n\n3. **Q Bar**\n   - **Description:** Texas barbeque staples such as brisket, ribs, and sausage.\n   - **Location:** Terminal B Level 2\n   - **Hours:** Mo-Su 06:00-21:00\n   - [Directions](https://maps.google.com/?q=29.985582,-95.345402)\n   - ![Q Bar](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/has--5.jpg)\n\n4. **Pappadeaux Seafood Kitchen**\n   - **Description:** Fresh seafood, large salads, flavorful pastas, and homemade desserts.\n   - **Location:** Terminal E Level 2\n   - **Hours:** Mo-Su 11:00-19:30\n   - [Directions](https://maps.google.com/?q=29.984669,-95.335287)\n   - ![Pappadeaux Seafood Kitchen](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/Pappadaeux2-E-IAH.jpg)\n   - [Menu](https://files.pappadeaux.com/images/dyn/menus/menu_2965.pdf)\n\n5. **Hubcap Grill & Beer Yard**\n   - **Description:** Voted \"Houston's Best Burger\" with fresh ground beef patties and locally baked buns.\n   - **Location:** Terminal A Level 2\n   - **Hours:** Mo-Su 05:00-20:00\n   - [Directions](https://maps.google.com/?q=29.98579,-95.350982)\n   - ![Hubcap Grill & Beer Yard](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Hubcap%20Grill.jpg)\n   - [Menu](http://hubcapgrill.com/index.html)\n\n6. **The Breakfast Klub**\n   - **Description:** Family-style restaurant with a soulful atmosphere.\n   - **Location:** Terminal A Level 2\n   - **Hours:** Mo-Fr 04:30-20:30; Su 04:30-20:30; Sa 04:30-19:30\n   - [Directions](https://maps.google.com/?q=29.987977,-95.34996)\n   - ![The Breakfast Klub](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-The%20Breakfast%20Klub-003-TANF-4-1706.jpg)\n   - [Menu](http://thebreakfastklub.com/)\n\n7. **Cadillac Mexican Kitchen & Tequila Bar**\n   - **Description:** Authentic Mexican food with a lively atmosphere.\n   - **Location:** Terminal A Level 2\n   - **Hours:** Mo-Su 07:00-22:00\n   - [Directions](https://maps.google.com/?q=29.985382,-95.350014)\n   - ![Cadillac Mexican Kitchen & Tequila Bar](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Cadillac%20Mexican%20Kitchen.jpg)\n   - [Menu](https://d14ik00wldmhq.cloudfront.net/media/filer_public/94/a5/94a553e1-a899-4095-ad1c-51c4d4d9020c/iah-dine-menu-cadillac-mexican-kitchen-and-tequilla-bartasf-5-rev-171016-gate-a15-180504.pdf)\n\n8. **Landry's Seafood**\n   - **Description:** Gulf Coast cuisine with sensational steaks, seafood, and pasta specialties.\n   - **Location:** Terminal C Level 2\n   - **Hours:** Mo-Fr 08:00-19:00; Su 08:00-19:00; Sa 12:00-17:00\n   - [Directions](https://maps.google.com/?q=29.985391,-95.338317)\n   - ![Landry's Seafood](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Landry's%20Seafood-003-TCSF-3-1706.jpg)\n   - [Menu](https://fly"
                }
              ]
            },
            "debug_info": null,
            "sources": null
          },
          "conversation_id": null,
          "is_final": false
        }
        """
        let testData = myString.data(using: .utf8, allowLossyConversion: true)
        let jsonData = myString.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let streamMessage = try decoder.decode(StreamMessage.self, from: jsonData)
            
            // Assert specific fields
            XCTAssertEqual(streamMessage.messagePart, 1251)
            XCTAssertEqual(streamMessage.messageId, "2024-08-27T23:55:04.570135+00:00")
            XCTAssertEqual(streamMessage.isFinal, false)
        } catch let DecodingError.dataCorrupted(context) {
            // Handle specific decoding error with context
            print("DBGG: Error decoding MessagePayload: \(context.debugDescription)")
            if let underlyingError = context.underlyingError as NSError? {
                ErrorHelper.handleDecodingError(error: underlyingError, in: myString)
            }
        } catch let error as NSError {
            // Handle other decoding errors
            ErrorHelper.handleDecodingError(error: error, in: myString)
        }
        

        
    }
}
