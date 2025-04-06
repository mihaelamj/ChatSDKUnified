//
//  HOUChatViewController.swift
//  ResChatHouAppKit
//
//  Created by Mihaela MJ on 23.10.2024..
//

import AppKit
import ResChatAppKitUI
import ResChatHouCommon
import ResChatSpeech

public class HOUChatViewController: ChatViewController {
    
    // MARK: init -
    
    public init(speechRecognizer: SpeechRecognizerProtocol? = nil) {
        super.init(imageProvider: HOUImageProvider(),
                   colorProvider: HOUColorProvider(),
                   speechRecognizer: speechRecognizer)
//        navigationBarProvider = HOUNavigationBarProvider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
