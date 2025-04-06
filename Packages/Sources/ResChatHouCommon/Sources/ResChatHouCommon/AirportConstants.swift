//
//  Consts.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation

public struct AirportConstants {
    public let urlString: String
    public let pathString: String
    public let appId: String = "has"
    public let name: String
    public let id: String
    public static let followSystemDarkAndLightMode = false
    
    // MARK: Init -
    
    internal init(urlString: String, pathString: String, name: String, id: String) {
        self.urlString = urlString
        self.pathString = pathString
        self.name = name
        self.id = id
    }
}

public extension AirportConstants {
    static let iah = AirportConstants(urlString: "https://nola-chat-dev3.responsum.ai",
                                      pathString: "/ws-public/socket.io/",
                                      name: "George Bush Intercontinental Airport",
                                      id: "IAH")
    static let hou = AirportConstants(urlString: "https://nola-chat-dev3.responsum.ai",
                                      pathString: "/ws-public/socket.io/",
                                      name: "William P. Hobby Airport",
                                      id: "HOU")
}
