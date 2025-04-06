//
//  ResChatSocket+Location.swift
//  
//
//  Created by Mihaela MJ on 31.08.2024..
//

public extension ResChatSocket {
    struct Location {
        public let latitude: Double
        public let longitude: Double
        
        // MARK: init -
        
        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}

public extension ResChatSocket {
    
    static func makeMetadataWithLocation(_ location: Location?,
                                         airportId: String,
                                         languageAbb: String) -> [String: Any] {
        var resultMetadata: [String: Any] = [
            "airport": airportId,
            "language": languageAbb
        ]
        
        if let loc = location {
            let locationDict: [String: Any] = [
                "latitude": loc.latitude,
                "longitude": loc.longitude
            ]
            resultMetadata["location"] = locationDict
        }
        
        return resultMetadata
    }
}
