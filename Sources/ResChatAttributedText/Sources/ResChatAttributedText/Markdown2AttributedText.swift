//
//  File.swift
//  
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation
import Down

#if canImport(UIKit)
import UIKit
public typealias FontType = UIFont
public typealias ColorType = UIColor
extension UIColor {
    func toCSSColor() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "rgba(%d, %d, %d, %.2f)", Int(red * 255), Int(green * 255), Int(blue * 255), alpha)
    }
}
#elseif canImport(AppKit)
import AppKit
public typealias FontType = NSFont
public typealias ColorType = NSColor

extension NSColor {
    func toCSSColor() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        usingColorSpace(.deviceRGB)?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "rgba(%d, %d, %d, %.2f)", Int(red * 255), Int(green * 255), Int(blue * 255), alpha)
    }
}
#endif


struct Markdown2AttributedText {
    
    /// Converts an `NSAttributedString` to markdown using Down.
    static func convertAttributedTextToMarkdown(_ attributedText: NSAttributedString) -> String {
        guard let downAttributedString = try? Down(markdownString: attributedText.string).toAttributedString() else {
            return attributedText.string // Fall back to plain text if Down conversion fails
        }
        return downAttributedString.string // Extract and return the raw markdown string
    }
    
    /// Converts markdown to  `NSAttributedString` using Down.
    static func convertMarkdownToAttributedString(markdownText: String) -> NSAttributedString? {
        convertMarkdownToAttributedStringStyled(markdownText: markdownText)
    }
    
    static func summarizeString(_ input: String?, upTo count: Int) -> String? {
        guard let input = input else { return nil }
        let prefixString = String(input.prefix(count))
        let remainingCharacters = input.count - prefixString.count
        let summary = "\(prefixString) (+ \(remainingCharacters) characters)"
        return summary
    }
    
}

private extension Markdown2AttributedText {
    static func convertMarkdownToAttributedStringDefault(markdownText: String) -> NSAttributedString? {
        do {
            let down = Down(markdownString: markdownText)
            let attributedString = try down.toAttributedString(.default, stylesheet: "body { font-size: 16px; }")
            return attributedString
        } catch {
            print("Error converting markdown to attributed string: \(error)")
            return nil
        }
    }
    
    static func convertMarkdownToAttributedStringStyled(markdownText: String) -> NSAttributedString? {
        do {
            let down = Down(markdownString: markdownText)
            
            #if os(iOS)
            let fontSize = FontType.preferredFont(forTextStyle: .body).pointSize
            let textColor = ColorType.label.toCSSColor()
            #elseif os(macOS)
            let fontSize = FontType.systemFontSize // macOS doesn't have preferredFont like iOS
            let textColor = ColorType.textColor.toCSSColor() // Use textColor for label equivalent on macOS
            #endif
            
            let stylesheet = """
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                font-size: \(fontSize)px;
                color: \(textColor);
            }
            """
            let attributedString = try down.toAttributedString(.default, stylesheet: stylesheet)
            return attributedString
        } catch {
            print("Error converting markdown to attributed string: \(error)")
            return nil
        }
    }
}
