//
//  ChatBotMessageCell.swift
//  ResChatAppKitUI
//
//  Created by Mihaela MJ on 09.12.2024..
//
#if os(macOS)
import AppKit
import ResChatUICommon

open class ChatBotMessageCell: ProvidingTableViewCell {
    override open class var identifier: String { "ChatBotMessageCell" }
    
    internal let messageLabel = NSTextField()
    internal let timestampLabel = NSTextField()
    internal let avatarContainerView = NSView()
    internal let avatarImageView = NSImageView()
    internal let iconImageView = NSImageView()
    internal let messageContainerView = NSView()
    
    internal var isAnimatingPlaceholder = false // Track placeholder animation state

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with message: UIMessage) {
        var checkedMessage = message
        checkedMessage.updateAttributedTextInNeeded()
        
        timestampLabel.stringValue = checkedMessage.date.description
//        configureForDebugging(with: checkedMessage.type)
        
        resetMessageLabelAnimation()
        
        if isEmptyBotHistory(message: checkedMessage) {
            updateMessageLabel(with: checkedMessage)
        } else if shouldAnimatePlaceholder(for: checkedMessage) {
            handlePlaceholderAnimation()
        } else {
            stopPlaceholderAnimation()
            updateMessageLabel(with: checkedMessage)
            
            if checkedMessage.isFinished && checkedMessage.origin == .updateItem {
                animatePulse()
            }
        }
    }
}

// MARK: - Handle States

private extension ChatBotMessageCell {
    func handlePlaceholderAnimation() {
        guard !isAnimatingPlaceholder else { return }
        
        let attributedText = createBotTypingAttributedText()
        messageLabel.attributedStringValue = attributedText
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.5
            context.allowsImplicitAnimation = true
            messageLabel.alphaValue = 0.5
        } completionHandler: {
            self.messageLabel.alphaValue = 1.0
        }
        
        isAnimatingPlaceholder = true
    }

    func stopPlaceholderAnimation() {
        isAnimatingPlaceholder = false
        resetMessageLabelAnimation()
    }
    
    func updateMessageLabel(with message: UIMessage) {
        if !message.attributexTextMatches() {
            var updatedMessage = message
            updatedMessage.updateAttributedTextInNeeded()
            messageLabel.attributedStringValue = updatedMessage.attributedText ?? NSAttributedString()
        } else {
            messageLabel.attributedStringValue = message.attributedText ?? NSAttributedString()
        }
    }
    
    func resetMessageLabelAnimation() {
        messageLabel.layer?.removeAllAnimations()
        messageLabel.alphaValue = 1.0
    }
    
    func isEmptyBotHistory(message: UIMessage) -> Bool {
        return (message.origin == .history) && message.isBotWaiting
    }
    
    func shouldAnimatePlaceholder(for message: UIMessage) -> Bool {
        return message.type == .placeholder(.forBot) && message.isBotWaiting
    }
    
    func createBotTypingAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Bot is typing... ", attributes: [
            .foregroundColor: NSColor.gray,
            .font: NSFont.systemFont(ofSize: 14)
        ])
        
        let attachment = NSTextAttachment()
        attachment.image = NSImage(systemSymbolName: "ellipsis.circle.fill", accessibilityDescription: nil)
        let symbolAttributedString = NSAttributedString(attachment: attachment)
        attributedText.append(symbolAttributedString)
        
        return attributedText
    }
    
    func createEmptyStringErrorAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Oops! No response. ", attributes: [
            .foregroundColor: NSColor.darkGray,
            .font: NSFont.systemFont(ofSize: 14)
        ])
        
        let attachment = NSTextAttachment()
        attachment.image = NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: nil)
        let symbolAttributedString = NSAttributedString(attachment: attachment)
        attributedText.append(symbolAttributedString)
        
        return attributedText
    }
}

// MARK: - Setup Views

private extension ChatBotMessageCell {
    func setupViews() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.isEditable = false
        messageLabel.isBezeled = false
        messageLabel.drawsBackground = false
        messageLabel.lineBreakMode = .byWordWrapping
        
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.isEditable = false
        timestampLabel.isBezeled = false
        timestampLabel.drawsBackground = false
        timestampLabel.lineBreakMode = .byTruncatingTail
        
        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainerView.wantsLayer = true
        avatarContainerView.layer?.cornerRadius = LayoutConstants.avatarSize / 2
        avatarContainerView.layer?.backgroundColor = Self.colorProvider.chatBotButtonBackground.cgColor
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = Self.imageProvider.chatBotIcon
        iconImageView.imageScaling = .scaleProportionallyUpOrDown
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.imageScaling = .scaleProportionallyUpOrDown
        avatarImageView.addSubview(iconImageView)
        
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        messageContainerView.wantsLayer = true
        messageContainerView.layer?.cornerRadius = LayoutConstants.containerCornerRadius
        messageContainerView.layer?.backgroundColor = Self.colorProvider.backgroundColor.cgColor
        
        addSubview(avatarContainerView)
        avatarContainerView.addSubview(avatarImageView)
        addSubview(messageContainerView)
        messageContainerView.addSubview(messageLabel)
        messageContainerView.addSubview(timestampLabel)
        
        NSLayoutConstraint.activate([
            avatarContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.avatarLeadingOffset),
            avatarContainerView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.avatarTopOffset),
            avatarContainerView.widthAnchor.constraint(equalToConstant: LayoutConstants.avatarSize),
            avatarContainerView.heightAnchor.constraint(equalToConstant: LayoutConstants.avatarSize),
            
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarContainerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: avatarContainerView.widthAnchor, multiplier: LayoutConstants.avatarContentMultiplier),
            avatarImageView.heightAnchor.constraint(equalTo: avatarContainerView.heightAnchor, multiplier: LayoutConstants.avatarContentMultiplier),
            
            iconImageView.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            messageContainerView.leadingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor, constant: LayoutConstants.containerLeadingOffset),
            messageContainerView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.containerTopOffset),
            messageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: LayoutConstants.containerTrailingOffset),
            messageContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: LayoutConstants.containerBottomOffset),
            
            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: LayoutConstants.messageLeadingOffset),
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: LayoutConstants.messageTopOffset),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: LayoutConstants.messageTrailingOffset),
            
            timestampLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: LayoutConstants.messageLeadingOffset),
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: LayoutConstants.timestampTopOffset),
            timestampLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: LayoutConstants.messageTrailingOffset),
            timestampLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: LayoutConstants.timestampBottomOffset)
        ])
    }
}
#endif
