//
//  IAHChatViewController.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 02.08.2024..
//

import UIKit
import ResChatUIKit
import ResChatHouCommon
import ResChatSpeech 

public class IAHChatViewController: ChatViewController {
    
    // MARK: Cell Types -

    override public class var userMessageCellType: UserMessageCell.Type {
        IAHUserMessageCell.self
    }
    
    override public class var chatBotMessageCellType: ChatBotMessageCell.Type{
        IAHChatBotMessageCell.self
    }
    
    override public class var loadingMessageCellType: LoadingTableViewCell.Type{
        IAHLoadingCell.self
    }
    
    // MARK: init -
    
    public init(speechRecognizer: SpeechRecognizerProtocol? = nil) {
        super.init(imageProvider: IAHImageProvider(), 
                   colorProvider: IAHColorProvider(),
                   speechRecognizer: speechRecognizer)
        self.navigationBarProvider = IAHNavigationBarProvider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions -
    
    override open func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
