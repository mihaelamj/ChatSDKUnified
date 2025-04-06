//
//  SpeechRecognizerProtocol.swift
//
//
//  Created by Mihaela MJ on 04.06.2024..
//

import Foundation

public protocol SpeechRecognizerProtocol {
    var onTextRecognized: ((String) -> Void)? { get set }
    var isRunning: Bool { get }
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func startRecording() throws
    func stopRecording()
}

public extension Notification.Name {
    static let didStartRecording = Notification.Name("didStartRecording")
    static let didFinishRecording = Notification.Name("didFinishRecording")
}
