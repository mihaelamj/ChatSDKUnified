//
//  MessageBufferingConfig.swift
//  
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation

// A struct to hold tweakable buffering settings for messages
struct MessageBufferingConfig {
    // Buffering configuration for streaming messages
    static let myMessagesBufferInterval: Int = 300      // Buffering time window in milliseconds
    static let myMessagesBufferMessageCount: Int = 16    // Max number of messages to buffer
}
