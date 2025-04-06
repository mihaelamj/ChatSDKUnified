//
//  ChatViewController+CallPublishers.swift
//
//
//  Created by Mihaela MJ on 10.09.2024..
//

import Foundation

// MARK: Send Message -

extension ChatViewController {
    func _sendUserMessage(_ text: String) {
        didTapSendUserMessageSubject.send(text)
        sendChatMessage(text)
    }
    
    func sendUserMessage(_ text: String) {
        if Thread.isMainThread {
            // Already on the main thread
            _sendUserMessage(text)
        } else {
            // Not on the main thread, dispatch to the main thread
            _sendUserMessage(text)
        }
    }
}

// MARK: Load More History Messages -

extension ChatViewController {
    func _loadMoreMessages() {
        didRequestMoreMessagesSubject.send(())
    }
    
    func requestLoadMoreMessagesIfPossible() {
        if Thread.isMainThread {
            // Already on the main thread
            _loadMoreMessages()
        } else {
            // Not on the main thread, dispatch to the main thread
            _loadMoreMessages()
        }
    }
}

// MARK: Clear Chat History -

extension ChatViewController {
    func _clearChatHistory() {
        didRequestToClearChatSubject.send(())
    }
    
    func clearChatHistory() {
        if Thread.isMainThread {
            // Already on the main thread
            _clearChatHistory()
        } else {
            // Not on the main thread, dispatch to the main thread
            _clearChatHistory()
        }
    }
}

// MARK: Speech Button -

extension ChatViewController {
    func _speechButtonAction() {
        didTapSpeechButtonSubject.send(())
    }
    
    func speechButtonAction() {
        if Thread.isMainThread {
            // Already on the main thread
            _speechButtonAction()
        } else {
            // Not on the main thread, dispatch to the main thread
            _speechButtonAction()
        }
    }
}

