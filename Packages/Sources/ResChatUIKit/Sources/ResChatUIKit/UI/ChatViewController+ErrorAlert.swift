//
//  ChatViewController+ErrorAlert.swift
//
//
//  Created by Mihaela MJ on 16.09.2024..
//

#if os(iOS)
import Foundation
import UIKit

class SocketAlertController {
    static func showSocketConnectionAlert(on viewController: UIViewController, connectionState: ConnectionState) {
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: "Error.", preferredStyle: .alert)

        // Add an image view for the SF Symbol
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue

        // Add the image view to the alert controller's view
        alertController.view.addSubview(imageView)

        // Set constraints for the image view
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Depending on the connection state, set the appropriate SF Symbol and animation
        switch connectionState {
        case .error1:
            imageView.image = UIImage(systemName: "powerplug.fill")
            imageView.tintColor = .systemRed
            rotateImageView(imageView) // Start the rotation animation
        case .error2:
            imageView.image = UIImage(systemName: "ev.plug.ac.gb.t.fill")
            imageView.tintColor = .systemCyan
        case .error3:
            imageView.image = UIImage(systemName: "xmark.circle.fill")
            imageView.tintColor = .systemRed
        }

        // Show the alert
        viewController.present(alertController, animated: true, completion: nil)

        // Dismiss the alert after 2 seconds for example
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }

    // Rotation animation for "connecting" state
    static private func rotateImageView(_ imageView: UIImageView) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1
        rotation.repeatCount = Float.infinity
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
}

// Example usage in a view controller

enum ConnectionState {
    case error1
    case error2
    case error3
}

extension ChatViewController {
    func showSocketErrorAlert() {
        // Example to show alert for connecting state
        SocketAlertController.showSocketConnectionAlert(on: self, connectionState: .error1)
        
//        // Simulate connected after 3 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            SocketAlertController.showSocketConnectionAlert(on: self, connectionState: .connected)
//        }
    }
}
#endif
