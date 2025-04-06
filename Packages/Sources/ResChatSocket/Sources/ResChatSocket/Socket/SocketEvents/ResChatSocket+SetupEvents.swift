//
//  ResChatSocket+SetupEvents.swift
//
//
//  Created by Mihaela MJ on 02.09.2024..
//

import Foundation

internal extension ResChatSocket {
    
    func setupSocketEvents() {
        setupConnectionSocketEvents()
        setupCustomSocketEvents()
    }
    
    func setupConnectionSocketEvents() {
        socket.on(SocketEventKey.connect.rawValue) { data, ack in
            TrafficLog.shared.logOnResponse(named: SocketEventKey.connect.rawValue, data: data)
            DispatchQueue.global().async { [self] in
                onConnect(data: data, ack: ack)
            }
        }

        socket.on(SocketEventKey.disconnect.rawValue) { data, ack in
            TrafficLog.shared.logOnResponse(named: SocketEventKey.disconnect.rawValue, data: data)
            DispatchQueue.global().async { [self] in
                onDisconnect(data: data, ack: ack)
            }
        }
        
        socket.on(SocketEventKey.error.rawValue) { data, ack in
            TrafficLog.shared.logOnResponse(named: SocketEventKey.error.rawValue, data: data)
            DispatchQueue.global().async { [self] in
                onError(data: data, ack: ack)
            }
        }
    }
    
    func setupCustomSocketEvents() {
        socket.on(SocketEventKey.sendHistorySnapshot.rawValue) { data, ack in
            TrafficLog.shared.logOnResponse(named: SocketEventKey.sendHistorySnapshot.rawValue, data: data)
            DispatchQueue.global().async { [self] in
                handleReceivedConversations(data: data, ack: ack)
            }
        }
        
        socket.on(SocketEventKey.streamMessage.rawValue) { data, ack in
            TrafficLog.shared.logOnResponse(named: SocketEventKey.streamMessage.rawValue, data: data)
            DispatchQueue.global().async { [self] in
                handleReceivedStreamMessages(data: data, ack: ack)
            }
        }
        
        socket.on(SocketEventKey.updateHistoryItem.rawValue) { data, ack in
            TrafficLog.shared.logOnResponse(named: SocketEventKey.updateHistoryItem.rawValue, data: data)
            DispatchQueue.global().async { [self] in
                handleReceivedUpdateHistoryItems(data: data, ack: ack)
            }
        }
    }
}

