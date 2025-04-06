//
//  IAHChatViewController.swift
//  ResChatHouAppKit
//
//  Created by Mihaela MJ on 23.10.2024..
//

import AppKit
import ResChatAppKitUI
import ResChatHouCommon
import ResChatSpeech

public class IAHChatViewController: ChatViewController {
    // MARK: init -
    
    public init(speechRecognizer: SpeechRecognizerProtocol? = nil) {
        super.init(imageProvider: IAHImageProvider(),
                   colorProvider: IAHColorProvider(),
                   speechRecognizer: speechRecognizer)
//        self.navigationBarProvider = IAHNavigationBarProvider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
