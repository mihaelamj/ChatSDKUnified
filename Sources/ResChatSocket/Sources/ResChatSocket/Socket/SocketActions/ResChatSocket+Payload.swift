//
//  ResChatSocket+Payload.swift
//
//
//  Created by Mihaela MJ on 06.09.2024..
//

import Foundation

internal extension ResChatSocket {
    // Enum to handle different payload types
    enum PayloadType {
        case welcomeMessage(externalAgentId: String?, conversationId: String?)
        case historySnapshot(externalAgentId: String?, conversationId: String?, lastMessageTs: String?, snapshotSize: Int)
        case sendMessage(externalAgentId: String?, conversationId: String?, message: String)
        case clearCacheMessage

    }

    // Unified function to create the payload based on the enum case
    func createPayload(for type: PayloadType) -> [String: Any] {
        var payload: [String: Any] = [
            SocketKey.connectionId.rawValue: connectionId ?? "",
            SocketKey.appId.rawValue: Self.appId,
            SocketKey.metadata.rawValue: myMetadata
        ]

        switch type {
        case .welcomeMessage(let externalAgentId, let conversationId):
            if let externalAgentId = externalAgentId {
                payload[SocketKey.externalAgentId.rawValue] = externalAgentId
            }
            if let conversationId = conversationId {
                payload[SocketKey.conversationId.rawValue] = conversationId
            }

        case .historySnapshot(let externalAgentId, let conversationId, let lastMessageTs, let snapshotSize):
            payload[SocketKey.snapshotSize.rawValue] = snapshotSize
            
            if let externalAgentId = externalAgentId {
                payload[SocketKey.externalAgentId.rawValue] = externalAgentId
            }
            if let conversationId = conversationId {
                payload[SocketKey.conversationId.rawValue] = conversationId
            }
            if let lastMessageTs = lastMessageTs {
                payload[SocketKey.lastMessageTs.rawValue] = lastMessageTs
            }

        case .sendMessage(let externalAgentId, let conversationId, let message):
            payload[SocketKey.message.rawValue] = message
            
            if let externalAgentId = externalAgentId {
                payload[SocketKey.externalAgentId.rawValue] = externalAgentId
            }
            if let conversationId = conversationId {
                payload[SocketKey.conversationId.rawValue] = conversationId
            }
        case .clearCacheMessage:
            break
        }

        return payload
    }
}
