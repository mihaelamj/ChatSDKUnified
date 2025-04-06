//
//  ChatViewController+EnableActions.swift
//  reschatui
//
//  Created by Mihaela MJ on 27.09.2024..
//

import Foundation

internal extension ChatViewController {
    
    enum BotTypingState {
        case idle
        case placeholderTyping
        case placeholderTypingDone
        case typing
        case typingDone
        
        var isTyping: Bool {
            switch self {
            case /**.typing,*/.placeholderTyping:
                return true
            default:
                return false
            }
        }
    }
    
    func setUserActionsEnabled(_ enabled: Bool) {
        sendButton.isEnabled = enabled
        if usesTextView {
            messageTextField.isEnabled = enabled
        } else {
            messageTextField.isEnabled = enabled
        }
    }
    
    func handleBotTypingState(_ state: BotTypingState) {
        isSendingEnabled = !state.isTyping
        setUserActionsEnabled(isSendingEnabled)
    }
}
