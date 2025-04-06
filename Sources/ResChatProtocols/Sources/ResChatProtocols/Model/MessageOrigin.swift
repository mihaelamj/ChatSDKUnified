//
//  MessageOrigin.swift
//  ResChatProtocols
//
//  Created by Mihaela MJ on 17.09.2024..
//

import Foundation

public enum MessageOrigin: String, CaseIterable {
    case history
    case updateItem
    case streaming
    case none
}
