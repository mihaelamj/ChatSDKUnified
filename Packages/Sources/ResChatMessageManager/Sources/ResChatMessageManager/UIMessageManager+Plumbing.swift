//
//  UIMessageManager+Plumbing.swift
//  ResChatMessageManager
//
//  Created by Mihaela MJ on 18.09.2024..
//

import Foundation
import ResChatUICommon

internal extension UIMessageManager {

    static func messagesAreOlder(_ messages: [UIMessage], thanOtherMessages: [UIMessage]) -> Bool {
        guard let earliestMessage = messages.min(by: { $0.date < $1.date }),
              let earliestOtherMessage = thanOtherMessages.min(by: { $0.date < $1.date }) else {
            // Fallback: assume messages are older if we can't compare
            return true
        }
        return earliestMessage.date < earliestOtherMessage.date
    }
    
    static func sortMessagesByDateAscending(messages: [UIMessage], andByIndex: Bool = false) -> [UIMessage] {
        return messages.sorted {
            if $0.date != $1.date {
                return $0.date < $1.date  // Sort by date first (ascending)
            }
            if andByIndex {
                return $0.messageIndex < $1.messageIndex  // Sort by index if the dates are the same and sorting by index is enabled
            }
            return false  // If both date and index are the same, retain the original order
        }
    }

    static func replaceUserPlaceholders(
        in messages: [UIMessage],
        with newMessages: [UIMessage],
        keepPlaceholderIfNoMatch: Bool = false
    ) -> [UIMessage] {
        return messages.compactMap { existingMessage -> UIMessage? in
            // Only proceed if the message is a placeholder for a user
            guard case .placeholder(.forUser) = existingMessage.type else {
                return existingMessage // Return non-placeholder messages as is
            }
            
            // Find the corresponding user message in newMessages with the same text
            if let matchingUserMessage = newMessages.first(where: { $0.type == .user && $0.text == existingMessage.text }) {
                var refreshedMessage = existingMessage
                refreshedMessage.update(with: matchingUserMessage)
                return refreshedMessage // Replace (update) the placeholder with the user message
            }
            
            // If no match, return the placeholder or nil depending on the flag
            return keepPlaceholderIfNoMatch ? existingMessage : nil
        }
    }
    
    static func replaceBotPlaceholders(
        in messages: [UIMessage],
        with newMessages: [UIMessage],
        keepPlaceholderIfNoMatch: Bool = false
    ) -> [UIMessage] {
        return messages.compactMap { existingMessage -> UIMessage? in
            // Only work with bot placeholders
            guard case .placeholder(.forBot) = existingMessage.type else { return existingMessage } // Return non-placeholder messages as is
            
            // Find the last bot message from newMessages that is waiting and not already in current messages
            if let matchingBotMessage = newMessages.last(where: {
                $0.type == .bot &&
                $0.isBotWaiting &&
                !Self.messages(messages, containMessage: $0)}) {
                
                var refreshedMessage = existingMessage
                refreshedMessage.update(with: matchingBotMessage)
                
                if existingMessage.origin == .history && matchingBotMessage.origin != .history {
                    print("Looki here")
                    print("Existing: \(existingMessage)")
                    print("Existing: \(matchingBotMessage)")
//                    refreshedMessage.origin = existingMessage.origin
                }
                return refreshedMessage // Replace (update) the placeholder with the matching bot message
            }
            
            // If no match, return the placeholder or nil based on keepPlaceholderIfNoMatch
            return keepPlaceholderIfNoMatch ? existingMessage : nil
        }
    }
    
    static func messages(_ messages: [UIMessage], containMessage: UIMessage) -> Bool {
        return messages.contains { candidate in
            containMessage.id == candidate.id
        }
    }
}

public extension UIMessageManager {
    func receivedMessagesAreOlder(_ receivedMessages: [UIMessage]) -> Bool {
        if uiMessages.isEmpty { return false }
        return Self.messagesAreOlder(receivedMessages, thanOtherMessages: uiMessages)
    }
}
