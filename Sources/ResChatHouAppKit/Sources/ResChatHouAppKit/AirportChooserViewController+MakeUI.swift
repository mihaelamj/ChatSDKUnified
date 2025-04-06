//
//  AirportChooserViewController+MakeUI.swift
//  ResChatHouAppKit
//
//  Created by Mihaela MJ on 17.09.2024..
//

import Foundation
import ResChatHouCommon
import ResChatSocket

public extension AirportChooserViewController {
    func handleSelection(airport: Airport, language: Language) {
        let chatViewController = airport.chatViewControllerForLanguage(language)
        handleSelection(delegate: delegate,
                        airport: airport,
                        language: language,
                        chatViewController: chatViewController)
    }
}
