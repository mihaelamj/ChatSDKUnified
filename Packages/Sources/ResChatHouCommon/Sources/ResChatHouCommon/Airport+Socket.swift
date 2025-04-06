//
//  Airport+Socket.swift
//  
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation
import ResChatSocket

public class IAHResChatSocket: ResChatSocket {
    override public class var urlString: String { AirportConstants.iah.urlString }
    override public class var urlPathString: String { AirportConstants.iah.pathString }
    override public class var appId: String { AirportConstants.iah.appId }
    override public class var airportId: String { Airport.iah.id }
}

public class HOUResChatSocket: ResChatSocket {
    override public class var urlString: String { AirportConstants.hou.urlString }
    override public class var urlPathString: String { AirportConstants.hou.pathString }
    override public class var appId: String { AirportConstants.hou.appId }
    override public class var airportId: String { Airport.hou.id }
}

public extension Airport {
    var socket: ResChatSocket {
        switch self {
        case .iah: return IAHResChatSocket()
        case .hou: return HOUResChatSocket()
        }
    }
}
