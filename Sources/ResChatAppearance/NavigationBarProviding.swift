//
//  NavigationBarProviding.swift
//
//
//  Created by Mihaela MJ on 05.06.2024..
//

#if os(iOS)
import UIKit
public typealias FontType = UIFont
#elseif os(macOS)
import AppKit
public typealias FontType = NSFont
#endif

public protocol NavigationBarProviding {
    var title: String { get }
    var font: FontType { get }
    var backgroundColor: ColorType { get }
    var textColor: ColorType { get }
    var rightButtonImage: ImageType? { get }
    var backButtonImage: ImageType? { get }
}
