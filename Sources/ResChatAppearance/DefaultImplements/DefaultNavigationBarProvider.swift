//
//  DefaultNavigationBarProvider.swift
//  
//
//  Created by Mihaela MJ on 05.06.2024..
//

public struct DefaultNavigationBarProvider: NavigationBarProviding {
    public var backgroundColor: ColorType { DefaultColorProvider().chatBotButtonBackground }
    public var textColor: ColorType { .white }
    public var rightButtonImage: ImageType? { DefaultImageProvider().clearAllIcon }
    public var title: String { "Airport HelpBot" }
    
    public init() {}

    // Font type based on platform
    public var font: FontType {
        #if os(iOS)
        return FontType.preferredFont(forTextStyle: .title1) // Use system font style on iOS
        #elseif os(macOS)
        return FontType.systemFont(ofSize: 24, weight: .bold) // Use system font on macOS
        #endif
    }

    public var backButtonImage: ImageType? { nil }
}
