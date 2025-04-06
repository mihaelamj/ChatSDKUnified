// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SocketIO
import Combine

open class ResChatSocket {
    
    // MARK: Combine -
    
    // Messages property -
    internal var _messages = CurrentValueSubject<[SocketMessage], Never>([])
    public var messages: AnyPublisher<[SocketMessage], Never> {
        _messages.eraseToAnyPublisher()
    }
    
    // Messages property -
    internal var _streamingMessage = CurrentValueSubject<SocketMessage, Never>(SocketMessage.none)
    public var streamingMessage: AnyPublisher<SocketMessage, Never> {
        _streamingMessage.eraseToAnyPublisher()
    }
    
    internal var _updatedMessage = CurrentValueSubject<SocketMessage, Never>(SocketMessage.none)
    public var updatedMessage: AnyPublisher<SocketMessage, Never> {
        _updatedMessage.eraseToAnyPublisher()
    }
    
    // Connection state property
    private var _connectionState = CurrentValueSubject<SocketConnectionState, Never>(.disconnected)
    public var connectionState: AnyPublisher<SocketConnectionState, Never> {
        _connectionState.eraseToAnyPublisher()
    }
    
    // MARK: SocketConnectionState -
    
    private func sendNewSocketConnectionState(_ newState: SocketConnectionState) {
        ParsedResponseLog.shared.logEvent(name: newState.name)
        _connectionState.send(newState)
    }
    
    private var lastKnownConnectedState: SocketConnectionState = .disconnected
    func sendNewConnectedState(_ newState: SocketConnectionState) -> Bool {
        guard newState.isEqualTo(.connected) || newState.isEqualTo(.disconnected) else { return false }
        
        // Check if the state is actually different or if forcing is required
        if !newState.isEqualTo(lastKnownConnectedState)  {
            
            // Update the last known state
            lastKnownConnectedState = newState

            // Send the state to subscribers
            sendNewSocketConnectionState(newState)
            
            return true
        }
        return false
    }
    
    func sendUpdateConnectionStateError(_ error: Error?) {
        if let socketError = error {
            sendNewSocketConnectionState(.error(socketError))
        } else {
            sendNewSocketConnectionState(.error(UnknownStateError.unknownState(message: "Unknown error")))
        }
    }
    
    private var lastKnownLoadingState: SocketConnectionState = .loaded
    func sendNewLoadingState(_ newState: SocketConnectionState) {
        guard newState.isEqualTo(.loading) || newState.isEqualTo(.loaded) else { return }
        
        // Check if the state is actually different or if forcing is required
        if !newState.isEqualTo(lastKnownLoadingState)  {
            
            // Update the last known state
            lastKnownLoadingState = newState
            
            // Send the state to subscribers
            sendNewSocketConnectionState(newState)
        }
    }
    
    private var lastKnownLoadingMoreState: SocketConnectionState = .loadedMore
    func sendNewLoadingMoreState(_ newState: SocketConnectionState) {
        guard newState.isEqualTo(.loadingMore) || newState.isEqualTo(.loadedMore) else { return }
        
        // Check if the state is actually different or if forcing is required
        if !newState.isEqualTo(lastKnownLoadingMoreState)  {
            
            // Update the last known state
            lastKnownLoadingMoreState = newState
            
            // Send the state to subscribers
            sendNewSocketConnectionState(newState)
        }
    }
    
    
    // MARK: Publishers -
    
    // Update messages with a check for duplicates
    func sendHistoryMessagesIfNeeded(newMessages: [SocketMessage], force: Bool = false) {
        if _messages.value != newMessages || force { // TODO: check equality checking -
            _messages.send(newMessages)
        }
    }
    
    func sendStreamingMessage(_ newMessage: SocketMessage) {
        _streamingMessage.send(newMessage)
    }
    
    func sendUpdatedMessage(_ newMessage: SocketMessage) {
        _updatedMessage.send(newMessage)
    }
    
    // MARK: Readonly -
    
    public var socketURL: URL {
        return URL(string: Self.urlString)!
    }
    
    // MARK: Class Properties -
    
    open class var urlString: String { "https://nola-chat-dev3.responsum.ai" }
    open class var urlPathString: String { "/ws-public/socket.io/" }
    open class var appId: String { "has" }
    open class var airportId: String { "IAH" }
    public static var language: String = "en"
    public static var location: Location? = nil
    open class var metadata: [String: Any] { makeMetadataWithLocation(location,
                                                                      airportId: airportId,
                                                                      languageAbb: language) }
    
    // MARK: Private Properties -
    
    private(set) var manager: SocketIO.SocketManager!
    private(set) var socket: SocketIOClient!
    private(set) var connectionId: String?
    private(set) var connectParams: [String: Any]
    
    // MARK: Private Helpers -

    // Pagination state
    internal(set) public var historyFinishedLoading = false
    // Loading flag
    internal(set) public var historyIsLoading = false {
        didSet {
            print("historyIsLoading = \(historyIsLoading ? "true" : "false")")
        }
    }

    // MARK: Public Properties -
    
    public var myLocation: Location?
    
    // Public myMetadata property that includes the location if set
    public var myMetadata: [String: Any] {
        Self.makeMetadataWithLocation(myLocation, airportId: Self.airportId, languageAbb: Self.language)
    }
    
    // MARK: Init -

    required public init() {
        let savedConnectionId = Self.retrieveOrGenerateConnectionId()
        self.connectionId = savedConnectionId
        
        self.connectParams =  [
            SocketKey.connectionId.rawValue: savedConnectionId,
            SocketKey.appId.rawValue: Self.appId,
            SocketKey.metadata.rawValue: Self.metadata
        ]
        setupSocket()
        setupSocketEvents()
        
        // Delete the log
        TrafficLog.shared.deleteLog()
        ParsedResponseLog.shared.deleteLog()
    }
    
    // MARK: Setup -

    private func setupSocket() {
        guard Self.retrieveConnectionId() != nil else {
            print("Cannot setup socket: connectionId is missing")
            return
        }
        
        manager = SocketIO.SocketManager(socketURL: socketURL, config: [
            .log(false),
            .compress,
            .path(Self.urlPathString),
        ])
        socket = manager.defaultSocket
    }
    
    internal func resetSocketHelperData() {
        // Reset the flags
        historyFinishedLoading = false
    }
    
    internal func clearCache() {
        sendHistoryMessagesIfNeeded(newMessages: [], force: true)
        resetSocketHelperData()
        sendNewLoadingState(.loading)
    }
}

// MARK: Emit/Send Socket Message -

internal extension ResChatSocket {
    func emitMessage(key: String,
                     payload: [String: Any],
                     callback: @escaping ([Any]) -> Void) {
        
        TrafficLog.shared.logEmitMessage(key: key, payload: payload)
        
        socket.emitWithAck(key,
                           with: [payload]).timingOut(after: 0) { data in
            callback(data)
        }
    }
    
    func sendSocketMessage(key: SocketMessageKey,
                           payload: [String: Any] = [:],
                           socketResponseCallback: @escaping (Response?, String?, String) -> Void = defaultSocketResponseCallback) {
        
        var fullPayload = payload
        fullPayload[SocketKey.connectionId.rawValue] = connectionId
        fullPayload[SocketKey.appId.rawValue] = Self.appId
        fullPayload[SocketKey.metadata.rawValue] = myMetadata
        
        emitMessage(key: key.rawValue, payload: fullPayload) { response in // [Any]
            TrafficLog.shared.logSocketCallback(key: key.rawValue, payload: payload, response: response)
            
            if let parsedResponse = Response.parse(from: response) {
                socketResponseCallback(parsedResponse, fullPayload[SocketKey.message.rawValue] as? String, key.rawValue)
            } else {
                socketResponseCallback(nil, fullPayload[SocketKey.message.rawValue] as? String, key.rawValue)
            }
        }
    }
}

public extension ResChatSocket {
    static func defaultSocketResponseCallback(response: Response?, message: String?, key: String) {
        let theResponse = response?.description ?? "Nil Response"
//        print("DBGG: emitSocketMessage Callback Response for `\(key)`: \(theResponse), \(message ?? "Nil message")")
    }
}

// MARK: ConnectionId -

private extension ResChatSocket {
    
    static func generateAndSaveConnectionId() -> String {
        let connectionId = "mobile_iOS_\(UUID().uuidString)"
        UserDefaults.standard.set(connectionId, forKey: "connectionId")
        return connectionId
    }

    static func retrieveConnectionId() -> String? {
        return UserDefaults.standard.string(forKey: "connectionId")
    }

    static func deleteConnectionId() {
        UserDefaults.standard.removeObject(forKey: "connectionId")
    }
    
    static func retrieveOrGenerateConnectionId() -> String {
         Self.retrieveConnectionId() ?? Self.generateAndSaveConnectionId()
    }
}
