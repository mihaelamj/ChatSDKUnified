//
//  MessageOriginProviding.swift
//  ResChatProtocols
//
//  Created by Mihaela MJ on 17.09.2024..
//

import Foundation

public protocol MessageOriginProviding: Hashable, Equatable {
    var toMessageOrigin: MessageOrigin { get }
}
