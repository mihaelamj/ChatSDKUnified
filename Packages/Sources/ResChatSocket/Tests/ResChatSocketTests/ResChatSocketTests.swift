import XCTest
import SocketIO
@testable import reschatSocket

class ResChatSocketTests: XCTestCase {
    
    var socketManager = ResChatSocket()
    var connectionExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()

        connectionExpectation = expectation(description: "Socket should connect")
        
        NotificationCenter.default.addObserver(self, selector: #selector(socketConnected), name: .socketConnected, object: nil)
        
        socketManager.delegate_connect()
        
        wait(for: [connectionExpectation], timeout: 10.0)
    }
    
    @objc func socketConnected() {
        connectionExpectation.fulfill()
    }
    
    override func tearDown() {
        socketManager.disconnect()
//        socketManager = nil
        NotificationCenter.default.removeObserver(self, name: .socketConnected, object: nil)
        super.tearDown()
    }
    
    func testSomething() {
        //1. connect
        //2. wait for connected
        //3. send message
    }
    
    // MARK: New -
    
    func testSendMessage() {
        let expectation = self.expectation(description: "Socket should respond to send_message")
        
//        socketManager.sendUserMessage("Hello, can you help me?",
//                                  externalAgentId: "agent123",
//                                  conversationId: "conv456") { response, message, key in
//            XCTAssertEqual(key, "send_message")
//            XCTAssertNotNil(response)
//            let theResponse = response?.description ?? "Nil Response"
//            print("Response: \(theResponse)")
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testRequestHistorySnapshot() {
//        let expectation = self.expectation(description: "Socket should respond to request_history_snapshot")
//        
//        socketManager.requestHistorySnapshot(externalAgentId: "agent123",
//                                             conversationId: "conv456",
//                                             lastMessageTs: ISO8601DateFormatter().string(from: Date()),
//                                             snapshotSize: 30) { response, message, key in
//            XCTAssertEqual(key, "request_history_snapshot")
//            XCTAssertNotNil(response)
//            let theResponse = response?.description ?? "Nil Response"
//            print("Response: \(theResponse)")
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testRequestWelcomeMessage() {
        let expectation = self.expectation(description: "Socket should respond to request_welcome_message")
        
        socketManager._requestWelcomeMessage(externalAgentId: "agent123",
                                            conversationId: "conv456") { response, message, key in
            XCTAssertEqual(key, "request_welcome_message")
            XCTAssertNotNil(response)
            let theResponse = response?.description ?? "Nil Response"
            print("Response: \(theResponse)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
}
