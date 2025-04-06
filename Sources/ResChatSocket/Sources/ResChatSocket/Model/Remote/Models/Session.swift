//
//  Session.swift
//  
//
//  Created by Mihaela MJ on 21.08.2024..
//

import Foundation

public struct Session: Codable {
    let active: Bool
    let agentId: String?
    let createdTimestamp: String
    let sessionId: String
    let sessionName: String

    enum CodingKeys: String, CodingKey {
        case active
        case agentId = "agent_id"
        case createdTimestamp = "created_timestamp"
        case sessionId = "session_id"
        case sessionName = "session_name"
    }
}
