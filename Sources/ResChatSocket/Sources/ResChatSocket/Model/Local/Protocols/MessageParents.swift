//
//  MessageParents.swift
//
//
//  Created by Mihaela MJ on 31.08.2024..
//

import Foundation

// MARK: Parent Protocol -

public protocol MessageParents {
    var conversationId: String? { get set }
    var historyId: String? { get set }
    
    func with(conversationId: String?, historyId: String?) -> Self
}

// MARK: Helper -

public extension MessageParents {
    func with(conversationId: String?, historyId: String?) -> Self {
        var copy = self
        copy.conversationId = conversationId
        copy.historyId = historyId
        return copy
    }
}
