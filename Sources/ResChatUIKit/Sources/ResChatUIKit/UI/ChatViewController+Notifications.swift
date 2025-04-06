//
//  ChatViewController+Notifications.swift
//  
//
//  Created by Mihaela MJ on 13.09.2024..
//
#if os(iOS)
import Foundation

extension Notification.Name {
    static let botPlaceholderStartedTyping = Notification.Name("botPlaceholderStartedTyping")
    static let botPlaceholderStoppedTyping = Notification.Name("botPlaceholderStoppedTyping")
    static let botStartedTyping = Notification.Name("botStartedTyping")
    static let botFinishedTyping = Notification.Name("botFinishedTyping")
}

internal extension ChatViewController {
    
    func subscribeToNotifications() {
        // Observe when bot starts and finishes typing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleBotPlaceholderStartedTyping),
                                               name: .botPlaceholderStartedTyping, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleBotPlaceholderStartedTyping),
                                               name: .botPlaceholderStartedTyping, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleBotStartedTyping),
                                               name: .botStartedTyping, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleBotFinishedTyping),
                                               name: .botFinishedTyping, object: nil)
    }
    
    @objc func handleBotPlaceholderStartedTyping() {
        handleBotTypingState(.placeholderTyping)
    }
    
    @objc func handleBotPlaceholderStoppedTyping() {
        handleBotTypingState(.placeholderTypingDone)
    }
    
    @objc func handleBotStartedTyping() {
        handleBotTypingState(.typing)
    }

    @objc func handleBotFinishedTyping() {
        handleBotTypingState(.typingDone)
    }
}


internal extension ChatViewController {
    
    func notifyBotPlaceholderStartedTyping() {
        NotificationCenter.default.post(name: .botPlaceholderStartedTyping, object: nil)
    }
    
    
    func notifyBotPlaceholderStoppedTyping() {
        NotificationCenter.default.post(name: .botPlaceholderStartedTyping, object: nil)
    }
    
    func notifyBotStartedTyping() {
        NotificationCenter.default.post(name: .botStartedTyping, object: nil)
    }

    func notifyBotFinishedTyping() {
        NotificationCenter.default.post(name: .botFinishedTyping, object: nil)
    }
}
#endif
