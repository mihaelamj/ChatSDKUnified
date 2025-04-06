//
//  UserMessageCell.swift
//  ResChatAppKitUI
//
//  Created by Mihaela MJ on 09.12.2024..
//
#if os(macOS)
import AppKit
import ResChatUICommon

// TODO: Add `waiting for bot` progress bar at the bottom of the cell, if this cell holds a message that is a `.placeholder(.forUser)`

extension NSFont {
    static var message: NSFont {
        return NSFont.systemFont(ofSize: 14, weight: .regular) // Adjust the size and weight as needed
    }
}

open class UserMessageCell: ProvidingTableViewCell {
    override open class var identifier: String { "UserMessageCell" }
    
    private let messageLabel = NSTextField()
    private let avatarContainerView = NSView()
    private let avatarImageView = NSImageView()
    private let iconImageView = NSImageView()
    private let messageContainerView = NSView()
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Configure messageLabel
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.isEditable = false
        messageLabel.isBezeled = false
        messageLabel.drawsBackground = false
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.font = .message
        messageLabel.textColor = Self.colorProvider.messageTextColor
        
        // Configure avatarContainerView
        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainerView.wantsLayer = true
        avatarContainerView.layer?.cornerRadius = LayoutConstants.avatarSize / 2
        avatarContainerView.layer?.backgroundColor = Self.colorProvider.userButtonBackground.cgColor

        // Configure iconImageView
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = Self.imageProvider.userIcon
        iconImageView.contentTintColor = Self.colorProvider.backgroundColor
        iconImageView.imageScaling = .scaleProportionallyUpOrDown

        // Configure avatarImageView
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.imageScaling = .scaleProportionallyUpOrDown
        avatarImageView.addSubview(iconImageView)
        
        // Configure messageContainerView
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        messageContainerView.wantsLayer = true
        messageContainerView.layer?.cornerRadius = LayoutConstants.containerCornerRadius
        messageContainerView.layer?.backgroundColor = Self.colorProvider.backgroundColor.cgColor

        // Add subviews
        addSubview(avatarContainerView)
        avatarContainerView.addSubview(avatarImageView)
        addSubview(messageContainerView)
        messageContainerView.addSubview(messageLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Avatar container constraints
            avatarContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.avatarLeadingOffset),
            avatarContainerView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.avatarTopOffset),
            avatarContainerView.widthAnchor.constraint(equalToConstant: LayoutConstants.avatarSize),
            avatarContainerView.heightAnchor.constraint(equalToConstant: LayoutConstants.avatarSize),
            
            // Avatar image constraints
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarContainerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: avatarContainerView.widthAnchor, multiplier: LayoutConstants.avatarContentMultiplier),
            avatarImageView.heightAnchor.constraint(equalTo: avatarContainerView.heightAnchor, multiplier: LayoutConstants.avatarContentMultiplier),
            
            // Icon image constraints
            iconImageView.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            iconImageView.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            
            // Message container constraints
            messageContainerView.leadingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor, constant: LayoutConstants.containerLeadingOffset),
            messageContainerView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.containerTopOffset),
            messageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: LayoutConstants.containerTrailingOffset),
            messageContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: LayoutConstants.containerBottomOffset),
            
            // Message label constraints
            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: LayoutConstants.messageLeadingOffset),
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: LayoutConstants.messageTopOffset),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: LayoutConstants.messageTrailingOffset),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: LayoutConstants.messageBottomOffset),
        ])
    }
    
    public func configure(with message: UIMessage) {
        messageLabel.stringValue = message.text ?? ""
//        configureForDebugging(with: message.type)
    }
}
#endif
