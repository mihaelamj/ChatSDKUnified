//
//  ProvidingTableViewCell.swift
//  
//
//  Created by Mihaela MJ on 04.06.2024..
//

import UIKit
import ResChatAppearance
import ResChatUICommon

open class ProvidingTableViewCell: UITableViewCell {
    open class var identifier: String { "ProvidingTableViewCell" }
    open class var imageProvider: ImageProviding { ResChatAppearance.DefaultImageProvider() }
    open class var colorProvider: ColorProviding {  ResChatAppearance.DefaultColorProvider() }
    
    func configureForDebugging(with type: UIMessageType) {
        return
        #if DEBUG
        let isDebugging = true
        #else
        let isDebugging = false
        #endif
        
        if type.isPlaceholder && isDebugging {
            // Remove background color and instead apply a gradient border for debugging
            self.contentView.backgroundColor = Self.colorProvider.backgroundColor
            
            // Create a neon blue gradient border
            let gradient = CAGradientLayer()
            gradient.frame = self.contentView.bounds
            gradient.colors = [
                UIColor(red: 0.0, green: 0.7, blue: 1.0, alpha: 1.0).cgColor,  // Neon blue color
                UIColor(red: 0.0, green: 0.9, blue: 1.0, alpha: 1.0).cgColor   // Slightly brighter blue
            ]
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            
            let shape = CAShapeLayer()
            shape.lineWidth = 4  // Set the border width
            shape.path = UIBezierPath(roundedRect: self.contentView.bounds, cornerRadius: 8.0).cgPath
            shape.fillColor = UIColor.clear.cgColor
            shape.strokeColor = UIColor.black.cgColor  // Temporary black, replaced by gradient
            
            gradient.mask = shape  // Apply gradient as the border
            
            // Add the gradient border as a sublayer
            self.contentView.layer.addSublayer(gradient)
            
            // Add rounded corners
            self.contentView.layer.cornerRadius = 8.0
            self.contentView.layer.masksToBounds = true
            
            // Add a shadow effect for a polished look
            self.contentView.layer.shadowColor = UIColor.black.cgColor
            self.contentView.layer.shadowOpacity = 0.3
            self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.contentView.layer.shadowRadius = 4.0
            self.contentView.layer.masksToBounds = false
        } else {
            // Reset to the default background and remove shadow and gradient
            self.contentView.backgroundColor = Self.colorProvider.backgroundColor
            self.contentView.layer.cornerRadius = 0.0
            self.contentView.layer.shadowOpacity = 0.0
            self.contentView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })  // Remove gradient
        }
    }
}


// Protocol to handle cell configuration
protocol ConfigurableMessageCell {
    func configure(with message: UIMessage)
}

// Conforming your cells to the protocol
extension UserMessageCell: ConfigurableMessageCell {}
extension ChatBotMessageCell: ConfigurableMessageCell {}
extension LoadingTableViewCell: ConfigurableMessageCell {}

extension UIView {
    func startShineBorderAnimation() {
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.fromValue = UIColor.clear.cgColor
        borderColorAnimation.toValue = UIColor.systemBlue.cgColor
        borderColorAnimation.duration = 0.8
        borderColorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        borderColorAnimation.autoreverses = true
        borderColorAnimation.repeatCount = .infinity

        let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnimation.fromValue = 0
        borderWidthAnimation.toValue = 3
        borderWidthAnimation.duration = 0.8
        borderWidthAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        borderWidthAnimation.autoreverses = true
        borderWidthAnimation.repeatCount = .infinity

        // Add border color and width animations
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 3
        self.layer.add(borderColorAnimation, forKey: "borderColor")
        self.layer.add(borderWidthAnimation, forKey: "borderWidth")
    }
    
    func stopShineBorderAnimation() {
        self.layer.removeAnimation(forKey: "borderColor")
        self.layer.removeAnimation(forKey: "borderWidth")
    }
}

extension ProvidingTableViewCell {
    func animatePulse() {
        // Perform pulse animation: scale up and back to normal size
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // Scale up slightly
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform.identity // Return to original size
            })
        }
    }
}
