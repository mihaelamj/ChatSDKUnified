//
//  MessageType+Convert.swift
//  ResChatUICommon
//
//  Created by Mihaela MJ on 18.09.2024..
//

import Combine
import Foundation
import ResChatProtocols

public extension ResChatProtocols.MessageType  {
    func toUIMessageType() -> UIMessageType {
        switch self {
        case .user:
            return UIMessageType.user
        case .bot:
            return UIMessageType.bot
        }
    }
}
