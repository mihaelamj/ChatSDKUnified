//
//  DefaultChatProvider.swift
//
//
//  Created by Mihaela MJ on 01.08.2024..
//

import Foundation
import UIKit
import ResChatUICommon

extension ChatViewController: UITextProviding {
    
    // MARK: Plain Texts -
    
    public func addUserText(_ text: String) {
        let newMessage = UIMessage.newUserTextCell(text)
        var snapshot = dataSource.snapshot()
        snapshot.ensureSectionExists(.main)  // Ensure the .main section exists
        
        snapshot.appendItems([newMessage], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        messageTextField.text = ""
        scrollToBottom()
    }
    
    public func addChatbotText(_ text: String) {
        let newMessage = UIMessage.newChatBotTextCell(text)
        var snapshot = dataSource.snapshot()
        snapshot.ensureSectionExists(.main)  // Ensure the .main section exists
        
        snapshot.appendItems([newMessage], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        scrollToBottom()
    }
}

