//
//  DefaultSpeechRecognizer.swift
//
//
//  Created by Mihaela MJ on 05.06.2024..
//

import Foundation
import Speech
#if os(iOS) || os(tvOS) || os(watchOS)
import AVFoundation
#endif

@available(macOS 10.15, *)
public class DefaultSpeechRecognizer: NSObject, SpeechRecognizerProtocol, SFSpeechRecognizerDelegate {
    
    // MARK: Properties -
    
    private let speechRecognizer: SFSpeechRecognizer
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    #if os(macOS)
    private let needsAudioEngine = false
    #endif

    public var onTextRecognized: ((String) -> Void)?
    public var isRunning: Bool {
        return audioEngine.isRunning
    }
    
    // MARK: Init -
    
    public init(locale: Locale = Locale(identifier: "en-US")) { 
        self.speechRecognizer = SFSpeechRecognizer(locale: locale)!
        super.init()
        self.speechRecognizer.delegate = self
    }
    
    // MARK: Auth -

    public func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    completion(true)
                default:
                    completion(false)
                }
            }
        }
    }
    
    // MARK: Actions -

    public func startRecording() throws {
        if audioEngine.isRunning {
            stopRecording()
            return
        }

        try setupAudioSession()

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw NSError(domain: "SpeechRecognizerManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to create recognition request"])
        }

        recognitionRequest.shouldReportPartialResults = true
        setupRecognitionTask(with: recognitionRequest)

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        
        NotificationCenter.default.post(name: .didStartRecording, object: nil)
    }

    public func stopRecording() {
        audioEngine.inputNode.removeTap(onBus: 0) // added later
        
        audioEngine.stop()
        recognitionRequest?.endAudio()
        
        // Make sure we have the final transcription result
        recognitionTask?.finish()
        // Handle the final result in recognitionTask completion
        recognitionTask?.cancel()
        
        recognitionRequest = nil
        recognitionTask = nil
        
        NotificationCenter.default.post(name: .didFinishRecording, object: nil)
    }
    
    // MARK: Private -
    
    private func setupAudioSession() throws {
        #if os(iOS) || os(tvOS) || os(watchOS)
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        #elseif os(macOS)
        if needsAudioEngine {
            // Configure AVAudioEngine or log a message
            let audioEngine = AVAudioEngine()
            let inputNode = audioEngine.inputNode
            let format = inputNode.inputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, time in
                // Process audio buffer
            }
            audioEngine.prepare()
            try audioEngine.start()
            print("Audio engine started on macOS.")
        }
        #endif
    }

    private func setupRecognitionTask(with recognitionRequest: SFSpeechAudioBufferRecognitionRequest) {
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false

            if let result = result {
                self.onTextRecognized?(result.bestTranscription.formattedString)
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self.stopRecording()
            }
        }
    }
    
    // MARK: Delegate -

    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        // Handle the speech recognizer availability change
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, didHypothesizeTranscription transcription: SFTranscription) {
        // Detect when the user has stopped speaking
        if transcription.segments.last?.duration ?? 0 > 1.0 {
            stopRecording()
        }
    }
}
