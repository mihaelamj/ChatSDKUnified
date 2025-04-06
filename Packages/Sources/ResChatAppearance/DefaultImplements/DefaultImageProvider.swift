//
//  DefaultImageProvider.swift
//  
//
//  Created by Mihaela MJ on 05.06.2024..
//

public struct DefaultImageProvider: ImageProviding {
    public var chatBotIcon: ImageType? {
        return Self.systemImage(named: "bubble.left.fill")
    }
    public var userIcon: ImageType? {
        return Self.systemImage(named: "person.fill")
    }
    public var sendIcon: ImageType? {
        return Self.systemImage(named: "paperplane.fill")
    }
    public var clearAllIcon: ImageType? {
        return Self.systemImage(named: "trash")
    }
    
    public init() {}
}

extension ImageProviding {
    public static func systemImage(named: String) -> ImageType? {
        #if os(iOS)
        return ImageType(systemName: named) // iOS uses `UIImage(systemName:)`
        #elseif os(macOS)
        if #available(macOS 11.0, *) {
            // macOS 11.0 and newer can use `systemSymbolName`
            return ImageType(systemSymbolName: named, accessibilityDescription: nil)
        } else {
            // Fallback for older macOS versions (before macOS 11.0)
            return ImageType(named: named) // Use `NSImage(named:)` as a fallback for macOS < 11.0
        }
        #endif
    }
}
