//
//  SocketMessage.swift
//  
//
//  Created by Mihaela MJ on 21.08.2024..
//

import Foundation

public enum SocketMessageSource: String, CaseIterable {
    case history
    case historyUpdateItem
    case streaming
}

public struct SocketMessage: Hashable, MessageUnityProviding {
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    public var payload: String?
    
    public var text: String
    
    public var rawText: String?
    
    public var socketSource: SocketMessageSource
    
    public var messageTimestamp: String
    
    public var messageIndex: Int
    
    public var messagePartNumber: Int
    
    public var isBotMessage: Bool
    
    public var myMessage: Message
    
    public var isMessageFinished: Bool
    
    public var id: String { messageTimestamp }
    
    public var date: Date? {
        Self.dateFormatter.date(from: messageTimestamp)
    }
    
    // MARK: Hashable -
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(messageTimestamp)
    }

    public static func == (lhs: SocketMessage, rhs: SocketMessage) -> Bool {
        lhs.messageTimestamp == rhs.messageTimestamp
    }
    
    // MARK: Init -

    // Initializer using MessageDataProviding
    public init(from provider: MessageUnityProviding) {
        self.text = provider.text
        self.socketSource = provider.socketSource
        self.messageTimestamp = provider.messageTimestamp
        self.messageIndex = provider.messageIndex
        self.messagePartNumber = provider.messagePartNumber
        self.isBotMessage = provider.isBotMessage
        self.myMessage = provider.myMessage
        self.isMessageFinished = provider.isMessageFinished
        self.rawText = provider.rawText
        self.payload = provider.payload
    }
    
    // Static func to return default 'none' message
    public static var none: SocketMessage {
        return SocketMessage(from: DefaultNoneProvider())
    }
}

// Default provider for 'none' values
public struct DefaultNoneProvider: MessageUnityProviding {
    public var text: String = ""
    public var socketSource: SocketMessageSource = .history // Assuming .unknown exists in SocketMessageSource
    public var messageTimestamp: String = ""
    public var messageIndex: Int = 0
    public var messagePartNumber: Int = 0
    public var isBotMessage: Bool = false
    public var myMessage: Message = Message.none // Assuming Message.none() exists
    public var isMessageFinished: Bool = false
    public var rawText: String? = nil
    public var payload: String? = nil
}


extension SocketMessage {
    
    static func sortMessagesByDate(in messages: [SocketMessage], ascending: Bool = true) -> [SocketMessage] {
        // Sort the messages by their timestamp (converted to Date) in ascending order (oldest first)
        return messages.sorted(by: { firstMessage, secondMessage in
            guard let firstDate = firstMessage.date,
                  let secondDate = secondMessage.date else {
                return false // In case of invalid date parsing, fallback
            }
            return ascending
            ? (firstDate < secondDate)
            : (firstDate > secondDate)
        })
    }
    
    static func findOldestMessage(in messages: [SocketMessage]) -> SocketMessage? {
        let sortedMessages = sortMessagesByDate(in: messages)
        return sortedMessages.first
    }

    static func findNewestMessage(in messages: [SocketMessage]) -> SocketMessage? {
        let sortedMessages = sortMessagesByDate(in: messages)
        return sortedMessages.last
    }
}
