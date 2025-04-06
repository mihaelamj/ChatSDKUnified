//
//  ChatViewController+ProxyMessages.swift
//
//
//  Created by Mihaela MJ on 09.09.2024..
//

import Foundation
import Combine
#if os(iOS)
import UIKit
import ResChatUICommon

extension ChatViewController {
    
    func handleConnectionStateChange(_ state: UIConnectionState) {
        switch state {
        case .connected:
            break
        case .disconnected:
            break
        case .loading:
            // Show a loading indicator while the connection is being established
            showLoadingIndicator()
        case .loaded:
            // Hide any loading indicators and enable full interaction
            hideLoadingIndicator()
        case .error(_):
            showSocketErrorAlert()
        case .loadingMore:
            addLoadingMessage()
        case .loadedMore:
            removeLoadingMessage()
        }
    }
}

extension ChatViewController {
    
    func processHistoryMessages(_ receivedMessages: [UIMessage]) {
        guard let manager = self.messageManager else {
            print("Error: message manager is nil")
            return
        }
        
        UILog.shared.logHistoryMessages(receivedMessages: receivedMessages,
                                        currentMessages: dataSource.snapshot().itemIdentifiers)
        
        // Check for `clear chat` -
        if receivedMessages.isEmpty && didRequestToClearChat {
            didRequestToClearChat = false
            manager.clearMessages()
            updateUI(animated: true)
            hideLoadingIndicator()
            return
        }
        
        showLoadingIndicator()
        
        // Determine if received messages are older
        let receivedMessagesAreOlder = manager.receivedMessagesAreOlder(receivedMessages)
        
        manager.processHistoryMessages(receivedMessages)
        updateUI(animated: false)

        receivedMessagesAreOlder ? scrollToTop() : scrollToBottom()
        hideLoadingIndicator()
    }
    
    func processStreamingMessage(_ streamingMessage: UIMessage) {
        guard let manager = self.messageManager else {
            print("Error: message manager is nil")
            return
        }
        
        guard !streamingMessage.isDefaultEmptyMessage else {
            print("Skipping empty subscription messages!")
            return
        }
        
        UILog.shared.logStreamingMessage(streamingMessage)
        
        manager.processStreamingMessage(streamingMessage)
        updateUI(animated: false)
        
        if currentBotID == nil {
            currentBotID = streamingMessage.id
        } else {
            updateBotIDWithMessage(streamingMessage)
        }
        
        scrollToBottom()
    }
    
    func processUpdatedMessage(_ updatedMessage: UIMessage) {
        guard let manager = self.messageManager else {
            print("Error: message manager is nil")
            return
        }
        UILog.shared.logUpdatedMessage(updatedMessage)
        
        manager.processUpdatedMessage(updatedMessage)
        
        updateBotIDWithMessage(updatedMessage)
        
        updateUI(animated: false)
    }
}

// MARK: Plumbing -

private extension ChatViewController {
    func updateBotIDWithMessage(_ botMessage: UIMessage) {
        guard botMessage.type == .bot,
                botMessage.isFinished,
                let botID = currentBotID else { return }
        guard botMessage.id == botID else { return }
        currentBotID = nil
    }
}

// MARK: UI -

extension ChatViewController {
    func updateUI(animated: Bool) {
        
        guard let manager = self.messageManager else { return }
        
        messagesArrived()
        
        currentSnapshot = UIMessageSnapshot()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(manager.uiMessages, toSection: .main)
//        print("updateUI: " + (manager.uiMessages.last?.text ?? "No text"))
        dataSource.apply(currentSnapshot, animatingDifferences: animated)
    }
}

// MARK: Send UI Message (Placeholders)  -

internal extension ChatViewController {
    
    func sendUIMessage(_ message: String) {
        
        // Don't add any placeholders if we already have placeholders in the snapshot
        guard !dataSource.snapshot().hasUserOrBotPlaceholders() else {
            return
        }
        
        // add placeholder message
        addUserPlaceholderMessage(message)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.addBotPlaceholderMessage("")
        }
    }
    
    func sendUIText(with message: String) {
        // Add user message immediately
        addUserChatText(message)
        // Add a demo chatbot response with a delay of 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.addChatbotChatText("This is a demo response from the chatbot 🤖? Let me see 👀 what I have filed under: `\(message)`")
        }
    }
}
#endif
