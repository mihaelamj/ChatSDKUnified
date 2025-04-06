//
//  UIMessageProviding.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 14.09.2024..
//

import Foundation

public protocol MessageProviding {
    var text: String { get }
    var rawText: String? { get }
    var isFromBot: Bool { get }
    var timestamp: String { get }
    var messagePart: Int { get }
    var messageIndex: Int { get }
    var isFinished: Bool { get }
    var messageType: MessageType { get }
    var messageOrigin: MessageOrigin { get }
}

public extension MessageProviding {
    var messageType: MessageType {
        isFromBot ? .bot : .user
    }
}

public struct DefaultMessage: MessageProviding {
    public var text: String
    public var rawText: String?
    public var isFromBot: Bool
    public var timestamp: String
    public var messagePart: Int
    public var messageIndex: Int
    public var isFinished: Bool
    public var messageOrigin: MessageOrigin
    
    public init(text: String,
                rawText: String? = nil,
                isFromBot: Bool,
                timestamp: String,
                messagePart: Int,
                messageIndex: Int,
                isFinished: Bool,
                messageOrigin: MessageOrigin) {
        self.text = text
        self.rawText = rawText
        self.isFromBot = isFromBot
        self.timestamp = timestamp
        self.messagePart = messagePart
        self.messageIndex = messageIndex
        self.isFinished = isFinished
        self.messageOrigin = messageOrigin
    }
}

// Default `none` instance in the protocol extension
public extension MessageProviding {
    static var none: MessageProviding {
        return DefaultMessage(
            text: "",
            rawText: nil,
            isFromBot: false,
            timestamp: "",
            messagePart: 0,
            messageIndex: 0,
            isFinished: true,
            messageOrigin: .none
        )
    }
}
