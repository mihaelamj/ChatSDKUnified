//
//  ImageProviding.swift
//
//
//  Created by Mihaela MJ on 04.06.2024..
//
#if os(iOS)
import UIKit
public typealias ImageType = UIImage
#elseif os(macOS)
import AppKit
public typealias ImageType = NSImage
#endif

public protocol ImageProviding {
    var chatBotIcon: ImageType? { get }
    var userIcon: ImageType? { get }
    var sendIcon: ImageType? { get }
    var clearAllIcon: ImageType? { get }
}
