//
//  ChatBotMessageCell+Configure.swift
//
//  Created by Mihaela MJ on 18.09.2024..
//
#if os(iOS)
import UIKit
import ResChatUICommon

extension ChatBotMessageCell {
    public func configure(with message: UIMessage) {
        var checkedMessage = message
        checkedMessage.updateAttributedTextInNeeded()
        
        // Update timestamp and setup debugging configuration
        timestampLabel.text = checkedMessage.date.description
        configureForDebugging(with: checkedMessage.type)
        
        // Reset any ongoing animations on the messageLabel
        resetMessageLabelAnimation()
        
        if isEmptyBotHistory(message: checkedMessage) {
            // No animation needed, update message label directly
//            stopPlaceholderAnimation()
//            handleEmptyBotHistory(with: message)
            updateMessageLabel(with: checkedMessage)
        } else if shouldAnimatePlaceholder(for: checkedMessage) {
            // Handle placeholder animation for bot messages
            handlePlaceholderAnimation()
        } else {
            // Reset placeholder animation if it's not needed anymore
            stopPlaceholderAnimation()
            updateMessageLabel(with: checkedMessage)
            
            // If the message is finished and from a specific origin, apply pulse animation
            if checkedMessage.isFinished && checkedMessage.origin == .updateItem {
                animatePulse()
            }
        }
    }
}

// MARK: Handle States -

private extension ChatBotMessageCell {
    func handlePlaceholderAnimation() {
        guard !isAnimatingPlaceholder else { return }

        let attributedText = createBotTypingAttributedText()
        messageLabel.attributedText = attributedText
        
        // Animate placeholder
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse]) {
            self.messageLabel.alpha = 0.5
        } completion: { _ in
            self.messageLabel.alpha = 1.0
        }

        isAnimatingPlaceholder = true
    }

    func stopPlaceholderAnimation() {
        isAnimatingPlaceholder = false
    }
    
    func updateMessageLabel(with message: UIMessage) {
        if !message.attributexTextMatches() {
//            print("WARNING: Message text does not match attributed text")
            var updatedMessage = message
            updatedMessage.updateAttributedTextInNeeded()
            messageLabel.attributedText = updatedMessage.attributedText
        } else {
            messageLabel.attributedText = message.attributedText
        }
    }
    
    func handleEmptyBotHistory(with message: UIMessage) {
        let attributedText = createEmptyStringErrorAttributedText2()
        messageLabel.attributedText = attributedText
    }
}


private extension ChatBotMessageCell {
    // Example: Applying the text with a fade transition within a diffable data source cell configuration
    func configureCell(cell: UITableViewCell, with newText: String) {
        // Assuming cell has a textView
//        guard let textView = cell.textView else { return }

        // Generate the attributed text
//        let newAttributedString = updateAttributedString(for: newText)

        // Apply a Core Animation transition
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25) // Duration of the animation (250 ms)
        
        // Create a fade transition
        let transition = CATransition()
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // Apply the transition to the text view's layer
//        textView.layer.add(transition, forKey: "fadeTextTransition")
        
        // Update the textView's attributedText property with the new content
//        textView.attributedText = newAttributedString
        
        CATransaction.commit()
    }
}

private extension ChatBotMessageCell {

    // MARK: - Helper Methods

    func resetMessageLabelAnimation() {
        messageLabel.layer.removeAllAnimations()
        messageLabel.alpha = 1.0
    }

    func isEmptyBotHistory(message: UIMessage) -> Bool {
        return (message.origin == .history) // || message.origin == .updateItem)
        && message.isBotWaiting
    }

    func shouldAnimatePlaceholder(for message: UIMessage) -> Bool {
        return message.type == .placeholder(.forBot) && message.isBotWaiting
    }

    func createBotTypingAttributedText() -> NSAttributedString {
        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let symbolImage = UIImage(systemName: "ellipsis.circle.fill", withConfiguration: symbolConfiguration)?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)

        let attachment = NSTextAttachment()
        attachment.image = symbolImage

        let attributedText = NSMutableAttributedString(string: "Bot is typing... ")
        let symbolAttributedString = NSAttributedString(attachment: attachment)
        attributedText.append(symbolAttributedString)
        
        return attributedText
    }
    
    private func createEmptyStringErrorAttributedText() -> NSAttributedString {
        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let symbolImage = UIImage(systemName: "questionmark.circle", withConfiguration: symbolConfiguration)?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)

        let attachment = NSTextAttachment()
        attachment.image = symbolImage

        let attributedText = NSMutableAttributedString(string: "Oops! No response. ")
        let symbolAttributedString = NSAttributedString(attachment: attachment)
        
        attributedText.append(symbolAttributedString)
        return attributedText
    }
    
    private func createEmptyStringErrorAttributedText2() -> NSAttributedString {
        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let symbolImage = UIImage(systemName: "questionmark.circle", withConfiguration: symbolConfiguration)?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)

        let attachment = NSTextAttachment()
        attachment.image = symbolImage

        // Create an attributed string with "Oops!" bolded
        let attributedText = NSMutableAttributedString(string: "Oops!", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ])
        let normalText = NSAttributedString(string: " No response.", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ])
        
        attributedText.append(normalText)

        // Create the symbol and append it
        let symbolAttributedString = NSAttributedString(attachment: attachment)
        attributedText.append(symbolAttributedString)

        return attributedText
    }
}
#endif
