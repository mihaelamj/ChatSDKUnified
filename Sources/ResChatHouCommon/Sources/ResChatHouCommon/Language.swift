//
//  Language.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 20.08.2024..
//

import Foundation

public enum Language: String, CaseIterable {
    
    case english = "English"
    case spanish = "Spanish"
    case japanese = "Japanese"
    case chinese = "Chinese (Mandarin)"
    case arabic = "Arabic"
    case vietnamese = "Vietnamese"
    
    // Computed property for abbreviations
    
    public var abbreviation: String {
        switch self {
        case .english:
            return "en"
        case .spanish:
            return "es"
        case .japanese:
            return "ja"
        case .chinese:
            return "zh"
        case .arabic:
            return "ar"
        case .vietnamese:
            return "vi"
        }
    }
    
    public var localeString: String {
        switch self {
        case .english:
            return "en-US"
        case .spanish:
            return "es-ES"
        case .japanese:
            return "ja-JP"
        case .chinese:
            return "zh-CN"
        case .arabic:
            return "ar-SA"
        case .vietnamese:
            return "vi-VN"
        }
    }
    
    public var locale: Locale {
        createLocale(from: localeString)
    }
    
    private func createLocale(from identifier: String) -> Locale {
        let availableLocales = Locale.availableIdentifiers
        if availableLocales.contains(identifier) {
            return Locale(identifier: identifier)
        } else {
            print("Invalid locale identifier provided. Falling back to 'en-US'.")
            return Locale(identifier: "en-US")
        }
    }
}
