//
//  ResChatSocket+Merge.swift
//
//
//  Created by Mihaela MJ on 08.09.2024..
//

import Foundation

// MARK: Process -

internal extension ResChatSocket {
    
    // remove duplicates, sort by timestamp
    func normalizeHistoryMessages(_ historyMessages: [SocketMessage]) -> [SocketMessage] {
        let sorted = SocketMessage.sortMessagesByDate(in: historyMessages, ascending: true)
        let deduped = Array(Set(sorted))
        return sorted
    }
}
