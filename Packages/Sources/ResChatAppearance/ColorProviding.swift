//
//  ColorProviding.swift
//  
//
//  Created by Mihaela MJ on 04.06.2024..
//

#if os(iOS)
import UIKit
public typealias ColorType = UIColor
#elseif os(macOS)
import AppKit
public typealias ColorType = NSColor
#endif

public protocol ColorProviding {
    var chatBotButtonBackground: ColorType { get }
    var userButtonBackground: ColorType { get }
    var backgroundColor: ColorType { get }
    var timestampTextColor: ColorType { get }
    var messageTextColor: ColorType { get }
    var placeholderMessageTextColor: ColorType { get }
    var inputBorderColor: ColorType { get }
    var shadowColor: ColorType { get }
    var sendIconColor: ColorType { get }
    var textColor: ColorType { get }
}

