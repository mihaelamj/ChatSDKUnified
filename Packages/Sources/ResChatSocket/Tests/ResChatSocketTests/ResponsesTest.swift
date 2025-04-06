//
//  ResponsesTest.swift
//
//
//  Created by Mihaela MJ on 01.08.2024..
//

import XCTest
@testable import reschatSocket

class ResponsesTest: XCTestCase {
    func testDecodingOKResponse() {

        let okResponse = """
        {
            "success": true,
            "message": "Operation completed successfully."
        }
        """

        if let jsonData = okResponse.data(using: .utf8) {
            do {
                let response = try JSONDecoder().decode(ResponseOK.self, from: jsonData)
                print("Success: \(response.success)")
                if let message = response.message {
                    print("Message: \(message)")
                } else {
                    print("Message is null")
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
    }
    
    func testDecodingErrorResponse() {
        let errorResponse = """
        {
            "success": false,
            "error": "InvalidRequest",
            "message": "The request parameters are invalid."
        }
        """

        if let jsonData = errorResponse.data(using: .utf8) {
            do {
                let response = try JSONDecoder().decode(ResponseError.self, from: jsonData)
                print("Success: \(response.success)")
                print("Error: \(response.error)")
                if let message = response.message {
                    print("Message: \(message)")
                } else {
                    print("Message is null")
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
    }
}
