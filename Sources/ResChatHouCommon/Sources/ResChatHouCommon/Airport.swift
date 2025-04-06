//
//  Airport.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 20.08.2024..
//

import Foundation

public enum Airport: CaseIterable {
    case iah
    case hou
    
    public var id: String {
        switch self {
        case .iah: return AirportConstants.iah.id
        case .hou: return AirportConstants.hou.id
        }
    }
    
    public var name: String {
        switch self {
        case .iah: return AirportConstants.iah.name
        case .hou: return AirportConstants.hou.name
        }
    }
}




