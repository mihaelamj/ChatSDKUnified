//
//  UserMessageCell.swift
//  
//
//  Created by Mihaela MJ on 21.05.2024..
//
#if os(iOS)
import UIKit
import ResChatUICommon

// TODO: Add `waiting for bot` progress bar at the bottom of the cell, if this cell holds a message that is a `.placeholder(.forUser)`

open class UserMessageCell: ProvidingTableViewCell {
    override open class var identifier: String {  "UserMessageCell" }
    
    private let messageLabel = UILabel()
    private let avatarContainerView = UIView()
    private let avatarImageView = UIImageView()
    private let iconImageView = UIImageView()
    private let messageContainerView = UIView()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = Self.colorProvider.backgroundColor
        
        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainerView.layer.cornerRadius = LayoutConstants.avatarSize / 2
        avatarContainerView.clipsToBounds = true
        avatarContainerView.backgroundColor = Self.colorProvider.userButtonBackground

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = Self.imageProvider.userIcon
        iconImageView.tintColor = Self.colorProvider.backgroundColor
        iconImageView.contentMode = .scaleAspectFit

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.addSubview(iconImageView)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.font = .message
        messageLabel.textColor = Self.colorProvider.messageTextColor
        
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        messageContainerView.backgroundColor = Self.colorProvider.backgroundColor
        messageContainerView.layer.cornerRadius = LayoutConstants.containerCornerRadius
        
        contentView.addSubview(avatarContainerView)
        avatarContainerView.addSubview(avatarImageView)
        contentView.addSubview(messageContainerView)
        messageContainerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            avatarContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.avatarLeadingOffset),
            avatarContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.avatarTopOffset),
            avatarContainerView.widthAnchor.constraint(equalToConstant: LayoutConstants.avatarSize),
            avatarContainerView.heightAnchor.constraint(equalToConstant: LayoutConstants.avatarSize),
            
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarContainerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: avatarContainerView.widthAnchor, multiplier: LayoutConstants.avatarContentMultiplier),
            avatarImageView.heightAnchor.constraint(equalTo: avatarContainerView.heightAnchor, multiplier: LayoutConstants.avatarContentMultiplier),
            
            iconImageView.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            iconImageView.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            
            messageContainerView.leadingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor, constant: LayoutConstants.containerLeadingOffset),
            messageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.containerTopOffset),
            messageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.containerTrailingOffset),
            messageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: LayoutConstants.containerBottomOffset), 
            
            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: LayoutConstants.messageLeadingOffset),
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: LayoutConstants.messageTopOffset),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: LayoutConstants.messageTrailingOffset),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: LayoutConstants.messageBottomOffset),
        ])
        
        messageContainerView.accessibilityIdentifier = "User messageContainerView"
    }
    
    public func configure(with message: UIMessage) {
        messageLabel.attributedText = message.attributedText
        configureForDebugging(with: message.type)
    }
}
#endif
