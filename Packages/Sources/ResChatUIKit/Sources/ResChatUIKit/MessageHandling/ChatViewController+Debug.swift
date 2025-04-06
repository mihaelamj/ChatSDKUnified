//
//  ChatViewController+Debug.swift
//  
//
//  Created by Mihaela MJ on 17.09.2024..
//

import UIKit
import ResChatUICommon

extension ChatViewController {
    private func describeMessages(_ messages: [UIMessage], title: String) {
        func niceDateFrom(_ date: Date?) -> String {
            guard let date = date else { return "" }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy. HH:mm:ss"
            return dateFormatter.string(from: date)
        }
        print("DBGG: \(title) messages: \(messages.count) are ranging from \(niceDateFrom(messages.first?.date)) to \(niceDateFrom(messages.last?.date))")
    }
}
