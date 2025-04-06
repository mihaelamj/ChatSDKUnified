//
//  ChatViewController+TextViewDelegate.swift
//  reschatui
//
//  Created by Mihaela MJ on 25.09.2024..
//

import UIKit

extension ChatViewController: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.isScrollEnabled = size.height >= LayoutConstants.maxTextViewHeight
        textView.layer.cornerRadius = textView.frame.height / 2.0  // Adjust corner radius as the textView grows
        textView.invalidateIntrinsicContentSize()
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    // When the user begins editing, clear the placeholder
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.clearPlaceholder()
            textView.textColor = .label // Set the actual text color
            textView.font = UIFont.systemFont(ofSize: 17) // Normal input font
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text, !text.isEmpty, text != placeholderText {
            sendUserMessage(text)
            textView.clearPlaceholder()
        } else {
            textView.setPlaceholder(placeholderText, attributes: placeholderAttributes)
        }
    }
}


extension UITextView {
    func setPlaceholder(_ placeholder: String, attributes: [NSAttributedString.Key: Any]) {
        self.attributedText = NSAttributedString(string: placeholder, attributes: attributes)
    }
    
    func clearPlaceholder() {
        self.text = nil
    }
}
