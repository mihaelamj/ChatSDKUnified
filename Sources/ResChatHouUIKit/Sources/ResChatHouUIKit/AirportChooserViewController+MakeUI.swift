//
//  AirportChooserViewController+MakeUI.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 15.09.2024..
//
import Foundation
import ResChatHouCommon
import ResChatUIKit
import ResChatSocket

public extension AirportChooserViewController {
    func handleSelection(airport: Airport, language: Language) {
        let chatViewController = airport.chatViewControllerForLanguage(language)
        handleSelection(delegate: chooserDelegate,
                        airport: airport,
                        language: language,
                        chatViewController: chatViewController)
    }
}
