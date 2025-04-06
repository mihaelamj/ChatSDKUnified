//
//  Airport+AppKit.swift
//  ResChatHouAppKit
//
//  Created by Mihaela MJ on 17.09.2024..
//

import AppKit
import ResChatHouCommon
import ResChatAppKitUI
import ResChatSpeech

public extension Airport {
    func chatViewControllerForLanguage(_ language: Language) -> ChatViewController {
        let locale = language.locale
        switch self {
        case .iah: return IAHChatViewController(speechRecognizer: DefaultSpeechRecognizer(locale: locale))
        case .hou: return HOUChatViewController(speechRecognizer: DefaultSpeechRecognizer(locale: locale))
        }
    }
}
