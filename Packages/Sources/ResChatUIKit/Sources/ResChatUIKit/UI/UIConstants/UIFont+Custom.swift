//
//  UIFont+Custom.swift
//  
//
//  Created by Mihaela MJ on 23.05.2024..
//

import UIKit

public extension UIFont {
    static func customFont(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func boldCustomFont(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }

    static func museoSansCondensedLight(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "MuseoSans-300", size: size)
    }

    static func museoSansCondensedRegular(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "MuseoSans-500", size: size)
    }

    static func museoSansCondensedBold(ofSize size: CGFloat) -> UIFont {
        return boldCustomFont(name: "MuseoSans-700", size: size)
    }
}

public extension UIFont {
    static let timestamp = museoSansCondensedLight(ofSize: 12)
    static let message = museoSansCondensedLight(ofSize: 16)
    static let inputPlaceholder = museoSansCondensedRegular(ofSize: 16)
    static let navigationTitle = museoSansCondensedBold(ofSize: 20)
}
