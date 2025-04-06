//
//  File.swift
//  ResChatUtil
//
//  Created by Mihaela MJ on 18.09.2024..
//

import Foundation

public extension Date {
    static func niceDateFrom(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy. HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    static func loggableCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy. HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}
