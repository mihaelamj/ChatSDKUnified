//
//  MessageDataProviding.swift
//
//
//  Created by Mihaela MJ on 21.08.2024..
//

import Foundation

// MARK: Message Source -

/**
 ID is the same in:
    StreamMessage. messageId
    HistoryUpdatedMessage.timestamp
    HistoryMessage.timestamp
 */

// MARK: Unity Protocol -

public protocol MessageUnityProviding {
    
    var socketSource: SocketMessageSource { get }
    
    var messageTimestamp: String { get }
    
    var messageIndex: Int { get }
    
    var messagePartNumber: Int { get }
    
    var isBotMessage: Bool { get }
    
    var myMessage: Message { get }
    
    var text: String { get }
    
    var rawText: String? { get }
    
    var isMessageFinished: Bool { get }
    
    var payload: String? { get }
}

// MARK: Default Implementations -

public extension MessageUnityProviding {
    
    var messageIndex: Int { 0 }
    
    var messagePartNumber: Int { 0 }
}

// MARK: Helper -

private extension String {
    func toAttributedMarkdown() -> NSAttributedString {
        if #available(macOS 12, iOS 15, *) {
            return (try? NSAttributedString(markdown: self)) ?? NSAttributedString(string: self)
        } else {
            return NSAttributedString(string: self)
        }
    }
}




