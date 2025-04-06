//
//  ChatBotMessageCell.swift
//  
//
//  Created by Mihaela MJ on 21.05.2024..
//
#if os(iOS)
import UIKit
import ResChatUICommon

open class ChatBotMessageCell: ProvidingTableViewCell {
    override open class var identifier: String { "ChatBotMessageCell" }
    
    internal let messageLabel = UILabel()
    internal let timestampLabel = UILabel()
    internal let avatarContainerView = UIView()
    internal let avatarImageView = UIImageView()
    internal let iconImageView = UIImageView()
    internal let messageContainerView = UIView()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTapGesture() {
        // Add gesture recognizer to messageLabel for handling taps
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMessageLabelTap(_:)))
        tapGesture.cancelsTouchesInView = false // Allow the touch to pass through to other views
        messageLabel.addGestureRecognizer(tapGesture)
        messageLabel.isUserInteractionEnabled = true  // Enable interaction on the label
        messageLabel.isUserInteractionEnabled = true
    }
    
    @objc private func handleMessageLabelTap(_ gesture: UITapGestureRecognizer) {
        guard let attributedText = messageLabel.attributedText else { return }

        // Get the location of the tap in the label
        let tapLocation = gesture.location(in: messageLabel)

        // Create the text layout components
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: messageLabel.bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = messageLabel.numberOfLines
        textContainer.lineBreakMode = messageLabel.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)

        // Get the character index at the tap location
        let boundingBox = layoutManager.usedRect(for: textContainer)
        let textOffset = CGPoint(
            x: (messageLabel.bounds.size.width - boundingBox.size.width) * 0.5 - boundingBox.origin.x,
            y: (messageLabel.bounds.size.height - boundingBox.size.height) * 0.5 - boundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(x: tapLocation.x - textOffset.x, y: tapLocation.y - textOffset.y)
        let characterIndex = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        if characterIndex < attributedText.length {
            // Check if there's a link at the tapped character
            if let link = attributedText.attribute(.link, at: characterIndex, effectiveRange: nil) as? URL {
                // Handle the URL tap (e.g., open the link)
                UIApplication.shared.open(link)
            } else {
                // Handle non-link tap
                print("Tapped text, but no link")
            }
        }
    }
    
    private func setupViews() {
        
        contentView.backgroundColor = Self.colorProvider.backgroundColor
        
        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainerView.layer.cornerRadius = LayoutConstants.avatarSize / 2
        avatarContainerView.clipsToBounds = true
        avatarContainerView.backgroundColor = Self.colorProvider.chatBotButtonBackground

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = Self.imageProvider.chatBotIcon
        iconImageView.tintColor = Self.colorProvider.backgroundColor
        iconImageView.contentMode = .scaleAspectFit

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.addSubview(iconImageView)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.font = .message
        messageLabel.textColor = Self.colorProvider.messageTextColor
        
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.font = .timestamp
        timestampLabel.textColor = Self.colorProvider.timestampTextColor
        
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        messageContainerView.backgroundColor = Self.colorProvider.backgroundColor
        messageContainerView.layer.cornerRadius = LayoutConstants.containerCornerRadius
        
        setupShadow()
        
        contentView.addSubview(avatarContainerView)
        avatarContainerView.addSubview(avatarImageView)

        contentView.addSubview(messageContainerView)
        messageContainerView.addSubview(messageLabel)
        messageContainerView.addSubview(timestampLabel)
        
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
            
            messageContainerView.leadingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor,
                                                          constant: LayoutConstants.containerLeadingOffset),
            messageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                      constant: LayoutConstants.containerTopOffset),
            messageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                           constant: LayoutConstants.containerTrailingOffset),
            messageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                         constant: LayoutConstants.containerBottomOffset),

            
            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: LayoutConstants.messageLeadingOffset),
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: LayoutConstants.messageTopOffset),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: LayoutConstants.messageTrailingOffset),
            
            timestampLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: LayoutConstants.messageLeadingOffset),
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: LayoutConstants.timestampTopOffset),
            timestampLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: LayoutConstants.messageTrailingOffset),
            timestampLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: LayoutConstants.timestampBottomOffset)
        ])

        messageContainerView.accessibilityIdentifier = "ChatBot messageContainerView"
        setupTapGesture()
    }

    internal var isAnimatingPlaceholder = false // Track if the animation is already running
    
    private func setupShadow() {
        messageContainerView.layer.shadowColor = Self.colorProvider.shadowColor.cgColor
        messageContainerView.layer.shadowOpacity = LayoutConstants.containerShadowOpacity
        messageContainerView.layer.shadowOffset = LayoutConstants.containerShadowOffset      
        messageContainerView.layer.shadowRadius = LayoutConstants.containerShadowRadius
    }
    
    static func summarizeString(_ input: String?, upTo count: Int) -> String? {
        guard let input = input else { return nil }
        let prefixString = String(input.prefix(count))
        let remainingCharacters = input.count - prefixString.count
        let summary = "\(prefixString) (+ \(remainingCharacters) characters)"
        return summary
    }
}
#endif
