//
//  ProvidingTableViewCell.swift
//  ResChatAppKitUI
//
//  Created by Mihaela MJ on 09.12.2024..
//
#if os(macOS)
import AppKit
import ResChatAppearance
import ResChatUICommon

open class ProvidingTableViewCell: NSTableCellView {
    // MARK: - Class Properties
    open class var identifier: String { "ProvidingTableViewCell" }
    open class var imageProvider: ImageProviding { ResChatAppearance.DefaultImageProvider() }
    open class var colorProvider: ColorProviding { ResChatAppearance.DefaultColorProvider() }
}

// Protocol to handle cell configuration
protocol ConfigurableMessageCell {
    func configure(with message: UIMessage)
}

// Example conforming cells
extension UserMessageCell: ConfigurableMessageCell {}
extension ChatBotMessageCell: ConfigurableMessageCell {}
extension LoadingTableViewCell: ConfigurableMessageCell {}

extension ProvidingTableViewCell {
    func animatePulse() {
        // Create a scale-up animation
        let scaleUpAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleUpAnimation.fromValue = 1.0
        scaleUpAnimation.toValue = 1.1
        scaleUpAnimation.duration = 0.2
        scaleUpAnimation.autoreverses = true // Automatically reverse the animation to scale down
        scaleUpAnimation.repeatCount = 1
        
        // Apply the animation to the cell's layer
        self.layer?.add(scaleUpAnimation, forKey: "pulse")
    }
}
#endif
