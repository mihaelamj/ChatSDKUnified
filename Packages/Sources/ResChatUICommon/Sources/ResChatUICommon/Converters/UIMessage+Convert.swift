//
//  UIMessage+Convert.swift
//  
//
//  Created by Mihaela MJ on 16.09.2024..
//

import Combine
import Foundation
import ResChatProtocols

extension UIMessage: MessageProviding {
    public var messageOrigin: ResChatProtocols.MessageOrigin {
        origin.toMessageOrigin()
    }
    
    public var isFromBot: Bool { isBot }
}

public extension MessageProviding {
    func toUIMessage() -> UIMessage {
        let uiType = messageType.toUIMessageType()
        let originType = messageOrigin.toUIMessageOrigin()
        
        let result = UIMessage.new(text: text,
                                   rawText: rawText,
                                   type: uiType,
                                   origin: originType,
                                   timestamp: timestamp,
                                   messagePart: messagePart,
                                   messageIndex: messageIndex,
                                   isFinished: isFinished)
        return result
    }
}
