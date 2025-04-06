//
//  HOU+UIProviding.swift DALLAS
//  ResChatUIApp
//
//  Created by Mihaela MJ on 04.06.2024..
//

// GREEN -

import ResChatAppearance

public struct HOUImageProvider: ImageProviding {
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

public struct HOUColorProvider: ColorProviding {
    public var chatBotButtonBackground: ColorType {
        let light = ColorType(red: 0.47, green: 0.75, blue: 0.42, alpha: 1.0)
        let dark = ColorType(red: 0.47, green: 0.75, blue: 0.42, alpha: 1.0)
        return Self.adaptiveColor(light: light,
                                  dark: AirportConstants.followSystemDarkAndLightMode ? dark : light)
    }
    
    public var userButtonBackground: ColorType {
        let light = ColorType(red: 0.23, green: 0.63, blue: 0.90, alpha: 1.0)
        let dark = ColorType(red: 0.23, green: 0.63, blue: 0.90, alpha: 1.0)
        return Self.adaptiveColor(light: light,
                                  dark: AirportConstants.followSystemDarkAndLightMode ? dark : light)
    }
    
    public var backgroundColor: ColorType {
        let light = ColorType.white
        let dark = ColorType.black
        return Self.adaptiveColor(light: light,
                                  dark: AirportConstants.followSystemDarkAndLightMode ? dark : light)
    }
    
    public var timestampTextColor: ColorType {
        let light = ColorType(red: 0.57, green: 0.62, blue: 0.67, alpha: 1.0)
        let dark = ColorType(red: 0.57, green: 0.62, blue: 0.67, alpha: 1.0)
        return Self.adaptiveColor(light: light,
                                  dark: AirportConstants.followSystemDarkAndLightMode ? dark : light)
    }
    
    public var messageTextColor: ColorType {
        let light = ColorType(red: 0.08, green: 0.10, blue: 0.16, alpha: 1.0)
        
        #if os(iOS) || os(tvOS) || os(watchOS)
        let dark = ColorType.label // Use `label` on iOS and similar platforms
        #elseif os(macOS)
        let dark = ColorType.textColor // Use `textColor` on macOS as an equivalent
        #endif

        return Self.adaptiveColor(light: light,
                                  dark: AirportConstants.followSystemDarkAndLightMode ? dark : light)
    }
    
    public var placeholderMessageTextColor: ColorType {
        let light = ColorType(red: 0.48, green: 0.48, blue: 0.48, alpha: 1.0)
        let dark = ColorType.gray
        return Self.adaptiveColor(light: light,
                                  dark: AirportConstants.followSystemDarkAndLightMode ? dark : light)
    }
    
    public var inputBorderColor: ColorType {
        let light = ColorType(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
        let dark = ColorType(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        return Self.adaptiveColor(light: light,
                                  dark: AirportConstants.followSystemDarkAndLightMode ? dark : light)
    }
    
    public var shadowColor: ColorType {
        let light = ColorType(red: 145/255.0, green: 158/255.0, blue: 171/255.0, alpha: 0.24)
        let dark = ColorType(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        return Self.adaptiveColor(light: light,
                                  dark: AirportConstants.followSystemDarkAndLightMode ? dark : light)
    }
    
    public var sendIconColor: ColorType {
        let light = ColorType(red: 0.08, green: 0.10, blue: 0.16, alpha: 1.0)
        let dark = ColorType.white
        return Self.adaptiveColor(light: light,
                                  dark: AirportConstants.followSystemDarkAndLightMode ? dark : light)
    }
    
    public var textColor: ColorType {
            let light = ColorType.black
            let dark = ColorType.white
        return Self.adaptiveColor(light: light,
                                  dark: AirportConstants.followSystemDarkAndLightMode ? dark : light)
    }
    
    public init() {}
}

public struct HOUNavigationBarProvider: NavigationBarProviding {
    public var backgroundColor: ColorType { HOUColorProvider().chatBotButtonBackground }
    public var textColor: ColorType { .white }
    public var rightButtonImage: ImageType? { HOUImageProvider().clearAllIcon }
    public var title: String { AirportConstants.hou.name }
    public var font: FontType { FontType.systemFont(ofSize: 20) }
    public var backButtonImage: ImageType? { HOUImageProvider.systemImage(named: "arrow.backward") }
    
    public init() {}
}





