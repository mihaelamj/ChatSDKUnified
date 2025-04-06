//
//  UIMessageType.swift
//
//
//  Created by Mihaela MJ on 02.09.2024..
//

import Foundation

public enum UIMessageType: Codable {
    case user
    case bot
    case placeholder(PlaceholderType)
    
    // Computed property to get a string representation
    public var stringValue: String {
        switch self {
        case .user:
            return "user"
        case .bot:
            return "bot"
        case .placeholder(let type):
            return "placeholder(\(type.rawValue))"
        }
    }
    
    // Initializer to create an instance from a string representation
    public init?(stringValue: String) {
        switch stringValue {
        case "user":
            self = .user
        case "bot":
            self = .bot
        default:
            if stringValue.starts(with: "placeholder(") {
                let typeRawValue = stringValue.dropFirst("placeholder(".count).dropLast()
                if let type = PlaceholderType(rawValue: String(typeRawValue)) {
                    self = .placeholder(type)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
    }
    
    // Array of all cases
    public static var allCases: [UIMessageType] {
        return [.user, .bot] + PlaceholderType.allCases.map { .placeholder($0) }
    }

    // Conformance to Codable
    private enum CodingKeys: String, CodingKey {
        case type, associatedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "user":
            self = .user
        case "bot":
            self = .bot
        case "placeholder":
            let associatedValue = try container.decode(PlaceholderType.self, forKey: .associatedValue)
            self = .placeholder(associatedValue)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .user:
            try container.encode("user", forKey: .type)
        case .bot:
            try container.encode("bot", forKey: .type)
        case .placeholder(let type):
            try container.encode("placeholder", forKey: .type)
            try container.encode(type, forKey: .associatedValue)
        }
    }
}

// Define the types of placeholder messages
public enum PlaceholderType: String, CaseIterable, Hashable, Codable {
    case forUser = "forUser"
    case forBot = "forBot"
    case forLoading = "forLoading"
}

// Conformance to Equatable
extension UIMessageType: Equatable {
    public static func == (lhs: UIMessageType, rhs: UIMessageType) -> Bool {
        switch (lhs, rhs) {
        case (.user, .user), (.bot, .bot):
            return true
        case let (.placeholder(lhsType), .placeholder(rhsType)):
            return lhsType == rhsType
        default:
            return false
        }
    }
}

// Conformance to Hashable
extension UIMessageType: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .user:
            hasher.combine("user")
        case .bot:
            hasher.combine("bot")
        case .placeholder(let type):
            hasher.combine("placeholder")
            hasher.combine(type)
        }
    }
}

extension UIMessageType {
    
    // Function to check if the message is a placeholder
    public var isPlaceholder: Bool {
        if case .placeholder = self {
            return true
        }
        return false
    }
    
    // Computed property to check if the message is either a bot or a placeholder for a bot
    public var isBotOrBotPlaceholder: Bool {
        switch self {
        case .bot:
            return true
        case .placeholder(let type) where type == .forBot:
            return true
        default:
            return false
        }
    }
    
    public var isUserOrUserPlaceholder: Bool {
        switch self {
        case .user:
            return true
        case .placeholder(let type) where type == .forUser:
            return true
        default:
            return false
        }
    }
    
    // Computed property to check if the message is a loading placeholder
    public var isLoadingPlaceholder: Bool {
        if case .placeholder(let type) = self, type == .forLoading {
            return true
        }
        return false
    }
    
    public var isUserOrBotPlaceholder: Bool {
        switch self {
        case .placeholder(let type) where type == .forUser:
            return true
        case .placeholder(let type) where type == .forBot:
            return true
        default:
            return false
        }
    }
}
