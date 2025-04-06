//
//  UIMessageSnapshot.swift
//  
//
//  Created by Mihaela MJ on 02.09.2024..
//

import UIKit
import ResChatUICommon

// Custom snapshot type alias
typealias UIMessageSnapshot = NSDiffableDataSourceSnapshot<ChatSection, UIMessage>

// MARK: Helper -

extension UIMessageSnapshot {
    mutating func ensureSectionExists(_ section: ChatSection = .main) {
        if sectionIdentifiers.isEmpty {
           appendSections([section])
        }
    }
    
    func hasUserOrBotPlaceholders() -> Bool {
        itemIdentifiers.contains(where: \.isUserOrBotPlaceholder)
    }
}
