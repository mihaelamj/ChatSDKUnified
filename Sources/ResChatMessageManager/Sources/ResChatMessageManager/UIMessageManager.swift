//
//  UIMessageManager.swift
//  ResChatMessageManager
//
//  Created by Mihaela MJ on 18.09.2024..
//

import Foundation
import ResChatUICommon

public class UIMessageManager {
    
    public typealias UpdateHandler = (UIMessageManager) -> Void
    
    private let updateHandler: UpdateHandler
    
    // MARK: Properties -
    
    private var _uiMessages = [UIMessage]()
    public var uiMessages: [UIMessage] { _uiMessages }
    
    // MARK: Init -
    
    public init(updateHandler: @escaping UpdateHandler) {
        self.updateHandler = updateHandler
    }
    
    // MARK: Private -
    
    private func updateMessages(_ messages: [UIMessage]) {
        _uiMessages = messages
    }
    
    private func callUpdateHandler() {
//        print("UIMessageManager: Calling update handler disabled for now!")
//        updateHandler(self)
    }
}

// MARK: Process -

public extension UIMessageManager {
    
    @MainActor
    func processSendMessageWith(text: String) {
        var currentMessages = _uiMessages
        currentMessages = Self.sortMessagesByDateAscending(messages: currentMessages)
        
        let newUserMessage = UIMessage.newPlaceholderUserMessage(text)
        currentMessages.append(newUserMessage)
        updateMessages(currentMessages)
        callUpdateHandler()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            Task { @MainActor in
                let newBotMessage = UIMessage.newPlaceholderBotMessage("")
                currentMessages.append(newBotMessage)
                self.updateMessages(currentMessages)
                self.callUpdateHandler()
            }
        }
    }
    
    func clearMessages() {
        _uiMessages.removeAll()
        updateMessages(_uiMessages)
    }
    
    func processHistoryMessages(_ receivedMessages: [UIMessage]) {
        var currentMessages = _uiMessages
        
        ProcessLog.shared.log(action: .processHistoryMessages, subActionName: "01. start", messages: currentMessages)
        
        // handle "P: [User]" case -> replace my `P: [User]` with `[User]`, or delete my user placeholder
        currentMessages = Self.replaceUserPlaceholders(in: currentMessages, with: receivedMessages)
        
        ProcessLog.shared.log(action: .processHistoryMessages, subActionName: "02. replaceUserPlaceholders", messages: currentMessages)
        
        // handle "P [Bot]" case -> replace my `P: [Bot]` with the received (probably Dummy "...") bot, or delete my bot placeholder
        currentMessages = Self.replaceBotPlaceholders(in: currentMessages, with: receivedMessages)
        
        ProcessLog.shared.log(action: .processHistoryMessages, subActionName: "03. replaceBotPlaceholders", messages: currentMessages)
        
        // Bot is Typing remains in the tableview, this should fix it
        // delete placeholders if needed
        currentMessages = currentMessages.filter { !$0.isPlaceholder } // Remove all placeholders -
        
        ProcessLog.shared.log(action: .processHistoryMessages, subActionName: "04. filter {!$0.isPlaceholder}", messages: currentMessages)
        
        // merge both arrays
        let mergedMessages = Array(Set(currentMessages + receivedMessages))
        
        // sort messages by date
        currentMessages = Self.sortMessagesByDateAscending(messages: mergedMessages)
        
        ProcessLog.shared.log(action: .processHistoryMessages, subActionName: "05. merge & sort", messages: currentMessages)
        
        updateMessages(currentMessages)
        callUpdateHandler()
    }
    
    func processStreamingMessage(_ streamingMessage: UIMessage) {
        if !streamingMessage.isBot {
            print("Error: Received a streaming message that is not a bot!.")
        }
        var currentMessages = _uiMessages
        
        ProcessLog.shared.log(action: .processStreamingMessage, subActionName: "01. start", message: streamingMessage, messages: currentMessages)
        
        // delete placeholders if needed
        currentMessages = currentMessages.filter { !$0.isPlaceholder } // Remove all placeholders -
        
        ProcessLog.shared.log(action: .processStreamingMessage, subActionName: "02. filter {!$0.isPlaceholder}", messages: currentMessages)
        
        // update Bot with Bot/part
        currentMessages = currentMessages.map {
           if  ($0.id == streamingMessage.id
             && $0.messagePart < streamingMessage.messagePart
                && $0.isBot == true && streamingMessage.isBot == true) {
            var refreshedMessage = $0
               refreshedMessage.update(with: streamingMessage)
               
               return refreshedMessage
           } else {
               return $0
           }
        }
        
        ProcessLog.shared.log(action: .processStreamingMessage, subActionName: "03. update Bot with Bot/part", messages: currentMessages)
        
        updateMessages(currentMessages)
        callUpdateHandler()
    }
    
    func processUpdatedMessage(_ updatedMessage: UIMessage) {
        var currentMessages = _uiMessages
        
        ProcessLog.shared.log(action: .processUpdatedMessage, subActionName: "01. start", message: updatedMessage, messages: currentMessages)
        
        // delete placeholders if needed
        currentMessages = currentMessages.filter { !$0.isPlaceholder } // Remove all placeholders -
        
        ProcessLog.shared.log(action: .processUpdatedMessage, subActionName: "02. filter {!$0.isPlaceholder}", messages: currentMessages)

        // Just update message in question, whether bot or user, but must be of the same type
        currentMessages = currentMessages.map {
            if ($0.id == updatedMessage.id
                && $0.isBot == updatedMessage.isBot) {
                var refreshedMessage = $0
                refreshedMessage.update(with: updatedMessage)
                   return refreshedMessage
            } else {
                return $0
            }
           
        }
        
        ProcessLog.shared.log(action: .processUpdatedMessage, subActionName: "03. update with update item", messages: currentMessages)
        
        updateMessages(currentMessages)
        callUpdateHandler()
    }
}


