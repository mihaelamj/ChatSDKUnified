//
//  UIMessage.swift
//
//
//  Created by Mihaela MJ on 21.05.2024..
//

import Foundation
import ResChatProtocols
import ResChatAttributedText

extension UIMessage: AttributedTextProviding {}

extension UIMessage: @unchecked Sendable {}

public enum ChatSection {
    case main
}

public struct UIMessage: Hashable, Codable {
    
    public var text: String 
    public var rawText: String?
    public var type: UIMessageType
    public var origin: UIMessageOrigin
    public let uuid: UUID
    public let date: Date
    public let timestamp: String
    public var id: String { timestamp }
    public var messagePart: Int = 0
    public var messageIndex: Int = 0
    public var isFinished: Bool = true
    public var attributedText: NSAttributedString

    // Conform to Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: UIMessage, rhs: UIMessage) -> Bool {
        return lhs.id == rhs.id &&
        Self.oneIsEqualToOther(one: lhs.attributedText, other: rhs.attributedText)
    }
    
    // Custom Codable conformance
    enum CodingKeys: String, CodingKey {
        case text
        case rawText
        case attributedText
        case type
        case uuid
        case date
        case timestamp
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        rawText = try container.decodeIfPresent(String.self, forKey: .rawText)
        type = try container.decode(UIMessageType.self, forKey: .type)
        origin = .none
        uuid = try container.decode(UUID.self, forKey: .uuid)
        date = try container.decode(Date.self, forKey: .date)
        timestamp = try container.decode(String.self, forKey: .timestamp)
        attributedText = AttributedTextCache.shared.getAttributedText(for: timestamp,
                                                                      messagePart: messagePart,
                                                                      isMessageComplete: isFinished,
                                                                      text: text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(rawText, forKey: .rawText)
        
        try container.encode(type, forKey: .type)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(date, forKey: .date)
        try container.encode(timestamp, forKey: .timestamp)
    }
    
    // Custom initializer
    public init(text: String,
                rawText: String? = nil,
                type: UIMessageType,
                origin: UIMessageOrigin,
                uuid: UUID = UUID(),
                date: Date = Date(),
                timestamp: String,
                messagePart: Int = 0,
                messageIndex: Int = 0,
                isFinished: Bool = true) {
        self.text = text
        self.rawText = rawText
        self.type = type
        self.origin = origin
        self.uuid = uuid
        self.date = date
        self.timestamp = timestamp
        self.messagePart = messagePart
        self.messageIndex = messageIndex
        self.isFinished = isFinished
        self.attributedText = AttributedTextCache.shared.getAttributedText(for: timestamp,
                                                                           messagePart: messagePart,
                                                                           isMessageComplete: isFinished,
                                                                           text: text)
    }
    
    public static var none: UIMessage {
        return UIMessage(
            text: "",
            rawText: nil,
            type: .user,
            origin: .none,
            uuid: UUID(),
            date: Date(),
            timestamp: "",
            messagePart: 0,
            messageIndex: 0,
            isFinished: true
        )
    }
}

public extension UIMessage {
    var isBot: Bool { type.isBotOrBotPlaceholder }
    var isUser: Bool { type.isUserOrUserPlaceholder }
    var isPlaceholder: Bool { type.isPlaceholder }
    var isUserOrBotPlaceholder: Bool { type.isUserOrBotPlaceholder }
    var isBotWaiting: Bool { isBot && (text.isEmpty || text == "...") }
    var isDefaultEmptyMessage: Bool {
        origin != .streaming
        && type == .user
        && text.isEmpty
        && timestamp.isEmpty
        && messagePart == 0
        && messageIndex == 0
    }
}

public extension UIMessage {
    
    static func new(text: String,
                    rawText: String?,
                    type: UIMessageType,
                    origin: UIMessageOrigin,
                    timestamp: String?,
                    messagePart: Int = 0,
                    messageIndex: Int = 0,
                    isFinished: Bool = true) -> UIMessage {
        
        let date = timestamp.flatMap { DateUtils.convertStringToDate($0) } ?? Date()
        let myTimestamp = timestamp ?? DateUtils.convertDateToString(date)
        
        let result = UIMessage(text: text,
                               rawText: rawText,
                               type: type,
                               origin: origin,
                               uuid: UUID(),
                               date: date,
                               timestamp: myTimestamp,
                               messagePart: messagePart,
                               messageIndex: messageIndex,
                               isFinished: isFinished)
        return result
    }
    
    /// Wiorks the same for `demo` mode and `real` mode
    static func newUserTextCell(_ text: String) -> UIMessage {
        new(text: text, 
            rawText: nil,
            type: .user,
            origin: .none,
            timestamp: nil)
    }
    
    static func newChatBotTextCell(_ text: String) -> UIMessage {
        new(text: text, 
            rawText: nil,
            type: .bot,
            origin: .none,
            timestamp: nil)
    }
    
    static func newPlaceholderLoadingMessage() -> UIMessage {
        new(text: "Loading", 
            rawText: nil,
            type: .placeholder(.forLoading),
            origin: .none,
            timestamp: nil)
    }
    
    static func newPlaceholderUserMessage(_ text: String) -> UIMessage {
        new(text: text,
            rawText: nil,
            type: .placeholder(.forUser),
            origin: .none,
            timestamp: nil)
    }
    
    static func newPlaceholderBotMessage(_ text: String, rawText: String? = nil) -> UIMessage {
        new(text: text,
            rawText: rawText,
            type: .placeholder(.forBot),
            origin: .none,
            timestamp: nil)
    }
}

// MARK: Helper -

private extension UIMessage {
    private struct DateUtils {
        static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX"
        
        static let dateFormatterQueue = DispatchQueue(label: "com.yourapp.dateFormatterQueue")

        static var dateFormatter: DateFormatter {
            return dateFormatterQueue.sync {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormat
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                return dateFormatter
            }
        }
        
        static func convertStringToDate(_ string: String) -> Date? {
            return dateFormatter.date(from: string)
        }
        
        static func convertDateToString(_ date: Date) -> String {
            return dateFormatter.string(from: date)
        }
    }
}

private extension UIMessage {
    static func currentDateAsId() -> Int {
        Int(Date().timeIntervalSince1970)
    }
    
    static func currentDateAsIdString() -> String {
        "\(currentDateAsId())"
    }
}


public extension UIMessage {
    mutating func update(with newMessage: UIMessage) {
        // Update the text and other relevant properties
        self.rawText = newMessage.rawText
        self.text = newMessage.text
        self.messagePart = newMessage.messagePart
        self.messageIndex = newMessage.messageIndex
        self.isFinished = newMessage.isFinished
        self.type = newMessage.type
        self.origin = newMessage.origin
        self.attributedText = newMessage.attributedText
        if !attributexTextMatches() {
            self.attributedText = AttributedTextCache.shared.getAttributedText(for: timestamp,
                                                                               messagePart: messagePart,
                                                                               isMessageComplete: isFinished,
                                                                               text: text)
        }
    }
      
    func attributexTextMatches() -> Bool {
        self.attributedText.string.isEqualIgnoringWhitespaceAndNewlines(to: text)
    }
    
    mutating func updateAttributedTextInNeeded() {
        if !attributexTextMatches() {
            self.attributedText = AttributedTextCache.shared.getAttributedText(for: timestamp,
                                                                               messagePart: messagePart,
                                                                               isMessageComplete: isFinished,
                                                                               text: text)
        }
    }
    
}

public extension UIMessage {
    static func sortByDate(in messages: [UIMessage], ascending: Bool = true) -> [UIMessage] {
       // Sort the messages by their timestamp (converted to Date) in ascending order (oldest first)
       return messages.sorted(by: { firstMessage, secondMessage in
           return ascending
           ? (firstMessage.date < secondMessage.date)
           : (firstMessage.date > secondMessage.date)
       })
   }
}


