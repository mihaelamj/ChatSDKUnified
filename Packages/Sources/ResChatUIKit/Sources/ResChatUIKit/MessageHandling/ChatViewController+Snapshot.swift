//
//  ChatViewController+Snapshot.swift
//
//
//  Created by Mihaela MJ on 03.09.2024..
//

import Foundation
import ResChatUICommon

internal extension ChatViewController {
    
    func addLoadingMessage() {
        
        var snapshot = dataSource.snapshot()
        
        // Ensure the section exists before checking or adding items
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }

        // Check if a loading message already exists in the snapshot
        if !snapshot.itemIdentifiers.contains(where: { $0.type.isLoadingPlaceholder }) {
            // Create a new placeholder loading message
            let loadingMessage = UIMessage.newPlaceholderLoadingMessage()
            UILog.shared.logPlaceholderMessage(loadingMessage)
            
            if let firstItem = snapshot.itemIdentifiers.first {
                // Insert the loading message before the first item
                snapshot.insertItems([loadingMessage], beforeItem: firstItem)
            } else {
                // If the snapshot is empty, just append the loading message
                snapshot.appendItems([loadingMessage], toSection: .main)
            }            
            // Apply the snapshot to the data source
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    func removeLoadingMessage() {
        
        var snapshot = dataSource.snapshot()
        
        // Check if the snapshot contains any items before trying to remove
        guard !snapshot.itemIdentifiers.isEmpty else { return }

        // Find all loading messages in the snapshot
        let loadingMessages = snapshot.itemIdentifiers.filter { $0.type.isLoadingPlaceholder }
        
        // Remove loading messages from the snapshot
        if !loadingMessages.isEmpty {
            snapshot.deleteItems(loadingMessages)
            
            // Apply the snapshot to the data source
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func addUserPlaceholderMessage(_ text: String) {
        let newMessage = UIMessage.newPlaceholderUserMessage(text)
        UILog.shared.logPlaceholderMessage(newMessage)
        var snapshot = dataSource.snapshot()
        
        // Ensure the section exists before adding items
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        
        snapshot.appendItems([newMessage], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        messageTextField.text = ""
        scrollToBottom()
    }
    
    func addBotPlaceholderMessage(_ text: String) {
        let newMessage = UIMessage.newPlaceholderBotMessage(text)
        UILog.shared.logPlaceholderMessage(newMessage)
        var snapshot = dataSource.snapshot()
        
        // Ensure the section exists before adding items
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        
        snapshot.appendItems([newMessage], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        scrollToBottom()
        
        notifyBotPlaceholderStartedTyping()
    }
    
    func messagesArrived() {
        notifyBotPlaceholderStoppedTyping()
    }

}
