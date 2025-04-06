//
//  ResChatSocket+InternalActions.swift
//
//
//  Created by Mihaela MJ on 05.09.2024..
//

import Foundation
import SocketIO

// MARK: Connection -

internal extension ResChatSocket {
    
    func _connect() {
        guard connectionId != nil else {
            TrafficLog.shared.logError(name: "connect: Cannot connect: connectionId is missing!")
            ParsedResponseLog.shared.logError(name: "connect: Cannot connect: connectionId is missing!")
            return
        }
        
        guard socket.status != .connected else {
            TrafficLog.shared.logError(name: "connect: Socket is already connected!")
            ParsedResponseLog.shared.logError(name: "connect: Socket is already connected!")
            return
        }
        
        resetSocketHelperData()

        TrafficLog.shared.logConnect(params: connectParams)
        socket.connect(withPayload: connectParams)
    }
    
    func _disconnect() {
        print("DBGG: Attempting to disconnect socket with appId: \(String(describing: Self.appId)) and connectionId: \(String(describing: connectionId))")
        
        guard socket.status == .connected else {
            TrafficLog.shared.logError(name: "connect: ERROR: Socket is already disconnected!!")
            ParsedResponseLog.shared.logError(name: "connect: ERROR: Socket is already disconnected!!")
            return
        }
        
        TrafficLog.shared.logDisconnect()
        socket.disconnect()
    }
}

// MARK: User Socket Message -

internal extension ResChatSocket {
    func _sendUserMessage(_ message: String,
                     externalAgentId: String? = nil,
                     conversationId: String? = nil,
                     socketResponseCallback: @escaping (Response?, String?, String) -> Void = defaultSocketResponseCallback) {

        guard socket.status == .connected else { return }
        let sendMessagePayload = createPayload(for: .sendMessage(externalAgentId: externalAgentId,
                                                                 conversationId: conversationId,
                                                                 message: message))
        
        sendSocketMessage(key: .sendMessage,
                          payload: sendMessagePayload,
                          socketResponseCallback: socketResponseCallback)
    }
}


// MARK: Welcome -

internal extension ResChatSocket {
    func _requestWelcomeMessage(externalAgentId: String? = nil, 
                                conversationId: String? = nil) {
        guard socket.status == .connected else { return }
        let welcomePayload = createPayload(for: .welcomeMessage(externalAgentId: externalAgentId,
                                                                conversationId: conversationId))
        sendSocketMessage(key: .requestWelcomeMessage,
                          payload: welcomePayload,
                          socketResponseCallback: Self.defaultSocketResponseCallback)
        ParsedResponseLog.shared.logEvent(name: "requestWelcomeMessage")
    }
}

// MARK: Clear Cache -

internal extension ResChatSocket {
    func _clearChatHistory() {
        guard socket.status == .connected else { return }
        let clearCachePayload = createPayload(for: .clearCacheMessage)
        sendSocketMessage(key: .clearHistory,
                          payload: clearCachePayload,
                          socketResponseCallback: Self.defaultSocketResponseCallback)
        clearCache()
        ParsedResponseLog.shared.logEvent(name: "clearChatHistory")
    }
}

// MARK: History Actions -

internal extension ResChatSocket {
    
    private func checkIsHistoryLoadingStateCorrect(_ errorMessage: String? = nil) -> Bool {
        sendNewLoadingState(.loaded)
        sendNewLoadingMoreState(.loadedMore)
        
        guard socket.status == .connected else {
            ParsedResponseLog.shared.logError(name: "\(errorMessage ?? "Load History Action") called while socket is disconnected!")
            return false
        }
        
        guard !historyIsLoading else {
            ParsedResponseLog.shared.logError(name: "\(errorMessage ?? "Load History Action") called while historyIsLoading == true!")
            return false
        }
        
        return true
    }

    // Request the initial batch of history messages from the socket
    func requestInitialHistorySnapshot(
        externalAgentId: String? = nil,
        conversationId: String? = nil,
        snapshotSize: Int = 30
    ) {
        guard checkIsHistoryLoadingStateCorrect("`requestInitialHistorySnapshot`") else { return }
        
        sendNewLoadingState(.loading)
        
        ParsedResponseLog.shared.logEvent(name: "requestInitialHistorySnapshot")
        historyFinishedLoading = false
        requestHistorySnapshotCommon(
            externalAgentId: externalAgentId,
            conversationId: conversationId,
            snapshotSize: snapshotSize
        )
    }

    // Request more messages if the history is not fully loaded
    func requestMoreMessages(
        externalAgentId: String? = nil,
        conversationId: String? = nil,
        snapshotSize: Int = 30
    ) {
        guard checkIsHistoryLoadingStateCorrect("`requestInitialHistorySnapshot`") else { return }
        let sortedMessages = SocketMessage.sortMessagesByDate(in: _messages.value)
        let oldestMessage = sortedMessages.first
        let newestMessage = sortedMessages.last

        guard !historyFinishedLoading,
              let lastMessage = oldestMessage else { return } //_messages.value.last(where: { $0.socketSource != .streaming }) else { return } // needs to be first

        ParsedResponseLog.shared.logEvent(name: "requestMoreMessages")
        
        sendNewLoadingMoreState(.loadingMore)
        
        requestHistorySnapshotCommon(
            externalAgentId: externalAgentId,
            conversationId: conversationId,
            lastMessageTs: lastMessage.messageTimestamp,
            snapshotSize: snapshotSize
        )
    }
}

// MARK: History Plumbing -

private extension ResChatSocket {

    // Common logic for requesting history snapshot
    func requestHistorySnapshotCommon(
        externalAgentId: String? = nil,
        conversationId: String? = nil,
        lastMessageTs: String? = nil,
        snapshotSize: Int = 30,
        completion: (() -> Void)? = nil
    ) {
        guard socket.status == .connected else { return }
        historyIsLoading = true

        let historyPayload = createPayload(
            for: .historySnapshot(
                externalAgentId: externalAgentId,
                conversationId: conversationId,
                lastMessageTs: lastMessageTs,
                snapshotSize: snapshotSize
            )
        )

        sendSocketMessage(
            key: .requestHistorySnapshot,
            payload: historyPayload,
            socketResponseCallback: Self.defaultSocketResponseCallback)
    }
}

