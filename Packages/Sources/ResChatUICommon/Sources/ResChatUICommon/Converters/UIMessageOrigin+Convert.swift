//
//  UIMessageOrigin+Convert.swift
//  ResChatUICommon
//
//  Created by Mihaela MJ on 18.09.2024..
//

import Combine
import Foundation
import ResChatProtocols

public extension ResChatProtocols.MessageOrigin  {
    func toUIMessageOrigin() -> UIMessageOrigin {
        switch self {
        case .history:
            return UIMessageOrigin.history
        case .updateItem:
            return UIMessageOrigin.updateItem
        case .streaming:
            return UIMessageOrigin.streaming
        case .none:
            return UIMessageOrigin.none
        }
    }
}

public extension UIMessageOrigin {
    func toMessageOrigin() -> ResChatProtocols.MessageOrigin {
        switch self {
        case .history:
            return .history
        case .updateItem:
            return .updateItem
        case .streaming:
            return .streaming
        case .none:
            return .none
        }
    }
}
