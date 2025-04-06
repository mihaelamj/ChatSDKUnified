//
//  HOUChatViewController.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 02.08.2024..
//

import UIKit
import ResChatUIKit
import ResChatHouCommon
import ResChatSpeech 

public class HOUChatViewController: ChatViewController {
    
    // MARK: Cell Types -
    
    override public class var userMessageCellType: UserMessageCell.Type {
        HOUUserMessageCell.self
    }
    
    override public class var chatBotMessageCellType: ChatBotMessageCell.Type{
        HOUChatBotMessageCell.self
    }
    
    override public class var loadingMessageCellType: LoadingTableViewCell.Type{
        HOULoadingCell.self
    }
    
    // MARK: init -
    
    public init(speechRecognizer: SpeechRecognizerProtocol? = nil) {
        super.init(imageProvider: HOUImageProvider(), 
                   colorProvider: HOUColorProvider(),
                   speechRecognizer: speechRecognizer)
        navigationBarProvider = HOUNavigationBarProvider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions -
    
    override open func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
