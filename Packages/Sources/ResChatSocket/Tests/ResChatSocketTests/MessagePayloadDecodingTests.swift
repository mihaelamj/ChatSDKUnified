//
//  MessagePayloadDecodingTests.swift
//
//
//  Created by Mihaela MJ on 31.08.2024..
//

import XCTest
@testable import reschatSocket

internal extension String {
    func decodeToMessagePayloadNew() -> Message? {
        // Unescape the JSON string by replacing escaped quotes and other characters
        let unescapedJsonString = self
            .replacingOccurrences(of: " \\\\", with: " \\")  // Handle double backslashes
        
        // Convert the unescaped string into Data
        guard let data = unescapedJsonString.data(using: .utf8) else {
            print("DBGG: Error converting string to Data")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            // Decode the data into a Message object
            let decodedPayload = try decoder.decode(Message.self, from: data)
            return decodedPayload
        } catch {
            print("DBGG: Error decoding MessagePayload: \(error)")
            return nil
        }
    }
}

class MessagePayloadDecodingTests: XCTestCase {
    
    
    let fuckedUpJsonString = """
    {
      "payload": "{\\"message\\": {\\"elements\\": [{\\"element\\": \\"text\\", \\"text\\": \\"It looks like there isn't a McDonald's at George Bush Intercontinental Airport (IAH). However, there are plenty of other dining options available. Here are a few you might find interesting:\\n\\n1. **The Line Sports Grill**\\n   - **Description:** Elevated sports bar and grill with quality, fresh ingredients.\\n   - **Location:** Terminal B Level 2\\n   - **Hours:** Mo-Su 06:00-21:00\\n   - [Directions](https://maps.google.com/?q=29.985953,-95.345823)\\n   - ![The Line Sports Grill](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/c181712e-d84b-460b-b8f7-0a8c25075cf2)\\n\\n2. **Pappadeaux Seafood Kitchen**\\n   - **Description:** Fresh seafood, large salads, flavorful pastas, and homemade desserts.\\n   - **Location:** Terminal E Level 2\\n   - **Hours:** Mo-Su 11:00-19:30\\n   - [Directions](https://maps.google.com/?q=29.984669,-95.335287)\\n   - ![Pappadeaux Seafood Kitchen](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/Pappadaeux2-E-IAH.jpg)\\n   - [Menu](https://files.pappadeaux.com/images/dyn/menus/menu_2965.pdf)\\n\\n3. **Hubcap Grill & Beer Yard**\\n   - **Description:** Voted \\\\"Houston's Best Burger\\\\\\" with fresh ground beef patties and locally baked buns.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Su 05:00-20:00\\n   - [Directions](https://maps.google.com/?q=29.98579,-95.350982)\\n   - ![Hubcap Grill & Beer Yard](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Hubcap%20Grill.jpg)\\n   - [Menu](http://hubcapgrill.com/index.html)\\n\\n4. **The Breakfast Klub**\\n   - **Description:** Family-style restaurant with a soulful atmosphere.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Fr 04:30-20:30; Su 04:30-20:30; Sa 04:30-19:30\\n   - [Directions](https://maps.google.com/?q=29.987977,-95.34996)\\n   - ![The Breakfast Klub](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-The%20Breakfast%20Klub-003-TANF-4-1706.jpg)\\n   - [Menu](http://thebreakfastklub.com/)\\n\\nI hope you find something delicious to enjoy!\\n\\n\\", \\"html_to_markdown\\": false, \\"attachment\\": null}], \\"surface\\": \\"chat_message\\", \\"render_only_for\\": [], \\"notification_text\\": null}, \\"sources\\": \\"search_services on pages 1-1\\", \\"thought_process\\": null, \\"debug_info\\": null}"
    }
    """
    
    let fuckedUpJsonStringMin = """
    {
      "payload": "{\\"message\\": {\\"elements\\": [{\\"element\\": \\"text\\", \\"text\\": \\"I Voted \\\\"Houston's Best Burger\\\\\\" with fresh ground beef patties and locally baked buns.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Su 05:00-20:00\\n   - [Directions](https://maps.google.com/?q=29.98579,-95.350982)\\n   - ![Hubcap Grill & Beer Yard](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Hubcap%20Grill.jpg)\\n   - [Menu](http://hubcapgrill.com/index.html)\\n\\n4. **The Breakfast Klub**\\n   - **Description:** Family-style restaurant with a soulful atmosphere.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Fr 04:30-20:30; Su 04:30-20:30; Sa 04:30-19:30\\n   - [Directions](https://maps.google.com/?q=29.987977,-95.34996)\\n   - ![The Breakfast Klub](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-The%20Breakfast%20Klub-003-TANF-4-1706.jpg)\\n   - [Menu](http://thebreakfastklub.com/)\\n\\nI hope you find something delicious to enjoy!\\n\\n\\", \\"html_to_markdown\\": false, \\"attachment\\": null}], \\"surface\\": \\"chat_message\\", \\"render_only_for\\": [], \\"notification_text\\": null}, \\"sources\\": \\"search_services on pages 1-1\\", \\"thought_process\\": null, \\"debug_info\\": null}"
    }
    """
    
    let fuckedUpJsonStringTest = """
    {
      "payload": "{\\"message\\": {\\"elements\\": [{\\"element\\": \\"text\\", \\"text\\": \\"It looks like there isn't a McDonald's at George Bush Intercontinental Airport (IAH). However, there are plenty of other dining options available. Here are a few you might find interesting:\\n\\n1. **The Line Sports Grill**\\n   - **Description:** Elevated sports bar and grill with quality, fresh ingredients.\\n   - **Location:** Terminal B Level 2\\n   - **Hours:** Mo-Su 06:00-21:00\\n   - [Directions](https://maps.google.com/?q=29.985953,-95.345823)\\n   - ![The Line Sports Grill](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/c181712e-d84b-460b-b8f7-0a8c25075cf2)\\n\\n2. **Pappadeaux Seafood Kitchen**\\n   - **Description:** Fresh seafood, large salads, flavorful pastas, and homemade desserts.\\n   - **Location:** Terminal E Level 2\\n   - **Hours:** Mo-Su 11:00-19:30\\n   - [Directions](https://maps.google.com/?q=29.984669,-95.335287)\\n   - ![Pappadeaux Seafood Kitchen](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/Pappadaeux2-E-IAH.jpg)\\n   - [Menu](https://files.pappadeaux.com/images/dyn/menus/menu_2965.pdf)\\n\\n3. **Hubcap Grill & Beer Yard**\\n   - **Description:** Voted \\"Houston's Best Burger\\\\\\" with fresh ground beef patties and locally baked buns.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Su 05:00-20:00\\n   - [Directions](https://maps.google.com/?q=29.98579,-95.350982)\\n   - ![Hubcap Grill & Beer Yard](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Hubcap%20Grill.jpg)\\n   - [Menu](http://hubcapgrill.com/index.html)\\n\\n4. **The Breakfast Klub**\\n   - **Description:** Family-style restaurant with a soulful atmosphere.\\n   - **Location:** Terminal A Level 2\\n   - **Hours:** Mo-Fr 04:30-20:30; Su 04:30-20:30; Sa 04:30-19:30\\n   - [Directions](https://maps.google.com/?q=29.987977,-95.34996)\\n   - ![The Breakfast Klub](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-The%20Breakfast%20Klub-003-TANF-4-1706.jpg)\\n   - [Menu](http://thebreakfastklub.com/)\\n\\nI hope you find something delicious to enjoy!\\n\\n\\", \\"html_to_markdown\\": false, \\"attachment\\": null}], \\"surface\\": \\"chat_message\\", \\"render_only_for\\": [], \\"notification_text\\": null}, \\"sources\\": \\"search_services on pages 1-1\\", \\"thought_process\\": null, \\"debug_info\\": null}"
    }
    """
    
    func testDecodeToMessagePayload11() throws {

        struct MockPayloadContainer: Codable {
            let payload: String
        }
        let testString = AnyArrayParser.cleanText(fuckedUpJsonStringTest) 
        print(testString)
        
        func parseMockPayloadContainerg(_ jsonString: String) -> MockPayloadContainer? {
            return StringParser.parseObjectFromString(jsonString, as: MockPayloadContainer.self)
        }
        
        let payloadContainer = parseMockPayloadContainerg(testString)
        XCTAssertNotNil(payloadContainer)
        
        print(payloadContainer)
    }
    
    /**
     
     ```swift
     do {
         // Convert the JSON data to a dictionary
         if let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
             
             // Extract the value for the key "d" and convert it back to Data
             if let key = response["d"] as? String,
                let strData = key.data(using: .utf8) {
                 
                 // Parse the nested JSON data
                 if let nestedResponse = try JSONSerialization.jsonObject(with: strData, options: []) as? [String: Any] {
                     
                     // Access the decoded value for "IsSuccess"
                     if let isSuccess = nestedResponse["IsSuccess"] {
                         print(isSuccess)   // => 1
                     }
                 }
             }
         }
     } catch {
         print("Failed to parse JSON: \(error)")
     }
     ```
     
     ```swift
     {
         "error_code": 0,
         "result": {
             "responseData": "{\"emeter\":{\"get_realtime\":{\"voltage_mv\":237846,\"current_ma\":81,\"power_mw\":7428,\"total_wh\":1920,\"err_code\":0}}}"
         }
     }
     
     required init(from decoder: Decoder) throws {

         let container = try decoder.container(keyedBy: CodingKeys.self)
         responseData = try container.decode(String.self, forKey: .responseData)
         let dataString = try container.decode(String.self, forKey: .responseData)
         emeter = try JSONDecoder().decode(Emeter.self, from: Data(dataString.utf8))
     }
     
     emeter = try JSONDecoder().decode(Emeter.self, from: Data(dataString.utf8))
     ```
     */
    
    func testDecodeToMessagePayload() throws {
        // JSON containing the payload as a string

        let jsonString = fuckedUpJsonString
        
        struct MockPayloadContainer: Codable {
            let payload: String
        }
        
        do {
            // Decode the JSON string into the container
            let unescaped = jsonString.unfucked()
            print(unescaped)
            let jsonData = unescaped.data(using: .utf8)!
            let decoder = JSONDecoder()
            
            let container = try decoder.decode(MockPayloadContainer.self, from: jsonData)
            
            // Use the provided function to decode the payload
            if let messageData = container.payload.decodeToMessagePayload() {
                print(messageData)
            } else {
                print("Error during decoding")
            }
        } catch let DecodingError.dataCorrupted(context) {
            // Print the context of the error
            print("Decoding error: \(context.debugDescription)")
            
            // If available, extract the specific error index
            if let underlyingError = context.underlyingError as NSError?,
               let errorIndex = underlyingError.userInfo["NSJSONSerializationErrorIndex"] as? Int {
                
                // Extract and print the offending part of the string
                let errorString = String(jsonString.dropFirst(errorIndex))
                print("Offending string: \(errorString.prefix(50))")  // Print first 50 characters from the error
                
                // Extract and print the exact offending character
                let offendingCharacter = jsonString[jsonString.index(jsonString.startIndex, offsetBy: errorIndex)]
                print("Offending character: '\(offendingCharacter)' at index \(errorIndex)")
            } else {
                print("Underlying error not found or index not available.")
            }
        } catch {
            print("Error during decoding: \(error)")
        }
    }
    
    func testDecodePayloadString() throws {
        let jsonString = fuckedUpJsonString
        let result = String.decodePayloadManually(from: jsonString)
        XCTAssertNotNil(result)
    }
}

public extension String {
    func unfucked() -> String {
        let offendingDoubleQuote =
            """
            \\\\"
            """
        let replacementDoubleQuote =
            """
            \\"
            """
        let unescaped = self
            .replacingOccurrences(of: offendingDoubleQuote, with: replacementDoubleQuote)
            .replacingOccurrences(of: offendingDoubleQuote, with: replacementDoubleQuote)
        return unescaped
    }
}

/**
 unescaped payload string
 
 "{\"message\": {\"elements\": [{\"element\": \"text\", \"text\": \"It looks like there isn't a McDonald's at George Bush Intercontinental Airport (IAH). However, there are plenty of other dining options available. Here are a few you might find interesting:\n\n1. **The Line Sports Grill**\n   - **Description:** Elevated sports bar and grill with quality, fresh ingredients.\n   - **Location:** Terminal B Level 2\n   - **Hours:** Mo-Su 06:00-21:00\n   - [Directions](https://maps.google.com/?q=29.985953,-95.345823)\n   - ![The Line Sports Grill](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/c181712e-d84b-460b-b8f7-0a8c25075cf2)\n\n2. **Pappadeaux Seafood Kitchen**\n   - **Description:** Fresh seafood, large salads, flavorful pastas, and homemade desserts.\n   - **Location:** Terminal E Level 2\n   - **Hours:** Mo-Su 11:00-19:30\n   - [Directions](https://maps.google.com/?q=29.984669,-95.335287)\n   - ![Pappadeaux Seafood Kitchen](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/Pappadaeux2-E-IAH.jpg)\n   - [Menu](https://files.pappadeaux.com/images/dyn/menus/menu_2965.pdf)\n\n3. **Hubcap Grill & Beer Yard**\n   - **Description:** Voted \"Houston's Best Burger\" with fresh ground beef patties and locally baked buns.\n   - **Location:** Terminal A Level 2\n   - **Hours:** Mo-Su 05:00-20:00\n   - [Directions](https://maps.google.com/?q=29.98579,-95.350982)\n   - ![Hubcap Grill & Beer Yard](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-Hubcap%20Grill.jpg)\n   - [Menu](http://hubcapgrill.com/index.html)\n\n4. **The Breakfast Klub**\n   - **Description:** Family-style restaurant with a soulful atmosphere.\n   - **Location:** Terminal A Level 2\n   - **Hours:** Mo-Fr 04:30-20:30; Su 04:30-20:30; Sa 04:30-19:30\n   - [Directions](https://maps.google.com/?q=29.987977,-95.34996)\n   - ![The Breakfast Klub](https://img.locuslabs.com/resize/A1S5SQXXRCG0RC/351x197cc/poi/IAH-Dine-The%20Breakfast%20Klub-003-TANF-4-1706.jpg)\n   - [Menu](http://thebreakfastklub.com/)\n\nI hope you find something delicious to enjoy!\n\n\", \"html_to_markdown\": false, \"attachment\": null}], \"surface\": \"chat_message\", \"render_only_for\": [], \"notification_text\": null}, \"sources\": \"search_services on pages 1-1\", \"thought_process\": null, \"debug_info\": null}"
 */

/**
 MMJ: Error decoding MessagePayload: The given data was not valid JSON.
 Decoding error: The data couldn’t be read because it isn’t in the correct format.
 Offending string: Houston's Best Burger" with fresh ground beef patt
 Offending character: 'H' at index 1150, line 19, column 29
 Error during decoding
 */

extension String {
    static func decodePayloadManually(from jsonString: String) -> String? {
        
        func findLineAndColumn(in jsonString: String, at index: Int) -> (line: Int, column: Int) {
            let lines = jsonString.prefix(index).split(separator: "\n", omittingEmptySubsequences: false)
            let line = lines.count
            let column = lines.last?.count ?? 0
            return (line, column)
        }
        
        let unescaped = jsonString.unfucked()
        print(unescaped)
        
        do {
            // Convert the entire JSON string into a dictionary to extract the payload
            if let jsonData = unescaped.data(using: .utf8),
               let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: [ .fragmentsAllowed]) as? [String: Any],
               let payloadString = jsonDict["payload"] as? String {
                
                // Decode the payload string using the provided function
                if let messageData = payloadString.decodeToMessagePayload() {
                    print("Successfully decoded: \(messageData)")
                } else {
                    print("Error during decoding")
                }
                return payloadString
            }
        } catch let DecodingError.dataCorrupted(context) {
            // Print the context of the error
            print("Decoding error: \(context.debugDescription)")
            
             // If available, extract the specific error index
            if let underlyingError = context.underlyingError as NSError?,
               let errorIndex = underlyingError.userInfo["NSJSONSerializationErrorIndex"] as? Int {
                
                // Extract and print the offending part of the string
                let errorString = String(jsonString.dropFirst(errorIndex))
                print("Offending string: \(errorString.prefix(50))")  // Print first 50 characters from the error
                
                // Extract and print the exact offending character
                let offendingCharacter = jsonString[jsonString.index(jsonString.startIndex, offsetBy: errorIndex)]
                print("Offending character: '\(offendingCharacter)' at index \(errorIndex)")
            } else {
                print("Underlying error not found or index not available.")
            }
        } catch {
            print("Error decoding: \(error)")
            if let nsError = error as? NSError {
                ErrorHelper.handleDecodingError(error: nsError, in: jsonString)
            }

        }
        return nil
    }
}


struct ErrorHelper {
    // Helper function for calculating line and column
    private static func findLineAndColumn(in jsonString: String, at index: Int) -> (line: Int, column: Int) {
        let lines = jsonString.prefix(index).split(separator: "\n", omittingEmptySubsequences: false)
        let line = lines.count
        let column = lines.last?.count ?? 0
        return (line, column)
    }
    
    // Error handling function
    static func handleDecodingError(error: NSError, in jsonString: String) {
        print("Decoding error: \(error.localizedDescription)")

        // If available, extract the specific error index
        if let errorIndex = error.userInfo["NSJSONSerializationErrorIndex"] as? Int {
            
            // Calculate line and column
            let (line, column) = findLineAndColumn(in: jsonString, at: errorIndex)
            
            // Extract and print the offending part of the string
            let offendingCharacter = jsonString[jsonString.index(jsonString.startIndex, offsetBy: errorIndex)]
            print("Offending string: \(jsonString.dropFirst(errorIndex).prefix(50))")
            print("Offending character: '\(offendingCharacter)' at index \(errorIndex), line \(line), column \(column)")
        } else {
            print("Underlying error not found or index not available.")
        }
    }
}
