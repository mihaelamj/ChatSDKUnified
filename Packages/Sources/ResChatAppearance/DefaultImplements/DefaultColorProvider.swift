//
//  DefaultColorProvider.swift
//
//
//  Created by Mihaela MJ on 05.06.2024..
//


public struct DefaultColorProvider: ColorProviding {

    public var textColor: ColorType {
        return Self.adaptiveColor(light: .black, dark: .white)
    }

    public var chatBotButtonBackground: ColorType {
        return Self.adaptiveColor(light: ColorType(red: 0.23, green: 0.63, blue: 0.90, alpha: 1.0),
                             dark: ColorType(red: 0.16, green: 0.49, blue: 0.77, alpha: 1.0))
    }

    public var userButtonBackground: ColorType {
        return Self.adaptiveColor(light: ColorType(red: 0.47, green: 0.75, blue: 0.42, alpha: 1.0),
                             dark: ColorType(red: 0.37, green: 0.65, blue: 0.35, alpha: 1.0))
    }

    public var backgroundColor: ColorType {
        return Self.adaptiveColor(light: .white, dark: .black)
    }

    public var timestampTextColor: ColorType {
        return Self.adaptiveColor(light: ColorType(red: 0.57, green: 0.62, blue: 0.67, alpha: 1.0),
                             dark: ColorType(red: 0.77, green: 0.82, blue: 0.87, alpha: 1.0))
    }

    public var messageTextColor: ColorType {
        return Self.adaptiveColor(light: ColorType(red: 0.08, green: 0.10, blue: 0.16, alpha: 1.0),
                             dark: .white)
    }

    public var placeholderMessageTextColor: ColorType {
        return Self.adaptiveColor(light: ColorType(red: 0.48, green: 0.48, blue: 0.48, alpha: 1.0),
                             dark: .lightGray)
    }

    public var inputBorderColor: ColorType {
        return Self.adaptiveColor(light: ColorType(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0),
                             dark: ColorType(red: 0.72, green: 0.72, blue: 0.72, alpha: 1.0))
    }

    public var shadowColor: ColorType {
        return Self.adaptiveColor(light: ColorType(red: 145/255.0, green: 158/255.0, blue: 171/255.0, alpha: 0.24),
                             dark: ColorType(red: 145/255.0, green: 158/255.0, blue: 171/255.0, alpha: 0.6))
    }

    public var sendIconColor: ColorType {
        return Self.adaptiveColor(light: ColorType(red: 0.08, green: 0.10, blue: 0.16, alpha: 1.0),
                             dark: .white)
    }
    
    public init() {}
}

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension ColorProviding {
    // Helper to create adaptive colors for both iOS and macOS
    public static func adaptiveColor(light: ColorType, dark: ColorType) -> ColorType {
        #if os(iOS)
        return ColorType { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
        #elseif os(macOS)
        if NSAppearance.current.name == .darkAqua {
            return dark
        } else {
            return light
        }
        #endif
    }
}
