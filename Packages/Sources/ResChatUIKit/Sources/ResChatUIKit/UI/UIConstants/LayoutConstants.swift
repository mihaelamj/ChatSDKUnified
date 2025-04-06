//
//  LayoutConstants.swift
//
//
//  Created by Mihaela MJ on 22.05.2024..
//

import UIKit

struct LayoutConstants {
    static let avatarSize: CGFloat = 32
    static let avatarLeadingOffset: CGFloat = 8
    static let avatarTopOffset: CGFloat = containerTopOffset + 10
    static let avatarContentMultiplier: CGFloat = 0.9
    
    static let containerLeadingOffset: CGFloat = 10
    static let containerTrailingOffset: CGFloat = -19
    static let containerTopOffset: CGFloat = 16
    static let containerBottomOffset: CGFloat = -16
    static let containerCornerRadius: CGFloat = 8
    static let containerBorderWidth: CGFloat = 1
    
    static let messageLeadingOffset: CGFloat = 23
    static let messageTopOffset: CGFloat = 19
    static let messageTrailingOffset: CGFloat = -23
    static let messageBottomOffset: CGFloat = -19
    
    static let timestampTopOffset: CGFloat = 19
    static let timestampBottomOffset: CGFloat = -19
    
    static let invisibleFooterHeight: CGFloat = 24
    
    static let messageInputContainerViewHeight: CGFloat = 56
    static let messageTextFieldHeight: CGFloat = 40
    
    static let sendButtonSide: CGFloat = 24
    static let sendButtonTrailing: CGFloat = 13
    
    static let microphoneButtonSide: CGFloat = 24
    static let microphoneButtonLeading: CGFloat = 21
    static let microphoneButtonTrailing: CGFloat = 14
    
    static let inputTextLeading: CGFloat = 16
    static let inputTextTrailing: CGFloat = 63
    
    static let inputPillLeading: CGFloat = 18
    static let inputPillTrailing: CGFloat = 9
    
    static let containerShadowOpacity: Float = 1.0
    static let containerShadowOffset: CGSize = CGSize(width: 0, height: 1) // Defaults to (0, -3).
    static let containerShadowRadius: CGFloat = 2
    
    static let minTextViewHeight: CGFloat = messageTextFieldHeight
    static let maxTextViewHeight: CGFloat = minTextViewHeight * 3.0
}

