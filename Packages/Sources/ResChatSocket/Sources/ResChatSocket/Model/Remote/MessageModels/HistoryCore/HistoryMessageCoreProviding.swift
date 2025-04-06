//
//  HistoryMessagesIntersectionProviding.swift
//  
//
//  Created by Mihaela MJ on 05.09.2024..
//

import Foundation

public protocol HistoryMessageCoreProviding {
    var common: HistoryMessageCore { get }
}

public extension HistoryMessageCoreProviding {
    var text: String { common.text }
    
    var rawText: String? { common.rawMessageText }
    
    var messageTimestamp: String { common.timestamp }
    
    var isBotMessage: Bool { common.origin == "bot" }
    
    var isMessageFinished: Bool { true }
    
    var myMessage: Message { common.decodedMessage }
    
    var payload: String? { common._payload }
}
