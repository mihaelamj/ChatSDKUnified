

import Foundation
import Combine
import ResChatSocket
import ResChatProtocols

public class SocketProxy {
    
    internal let socketProviding: (SocketEvent & SocketAction)?
    internal let uiProviding: UIEvent? // & ChatUIProxyPublishing
    internal var cancellables = Set<AnyCancellable>()
    
    // MARK: My Internal Publishers
    
    internal var _didChangeConnectionStatePublisher = CurrentValueSubject<ConnectionState, Never>(.disconnected)
    internal var _didReceiveMessagesPublisher = CurrentValueSubject<[MessageProviding], Never>([])
    internal var _didReceiveStreamingMessagePublisher = CurrentValueSubject<MessageProviding, Never>(DefaultMessage.none)
    internal var _didReceiveUpdatedMessagePublisher = CurrentValueSubject<MessageProviding, Never>(DefaultMessage.none)
    
    // MARK: init -
    
    public init(socketProviding: (SocketEvent & SocketAction)?,
         uiProviding: UIEvent?) {
        self.socketProviding = socketProviding
        self.uiProviding = uiProviding
        setupSocketSubscriptions()
        setupUISubscriptions()
    }
}

private extension SocketProxy {
    func setupSocketSubscriptions() {
        setupConnectionStateSubscription()
        setupMessagesSubscription()
        setupStreamingMessageBufferedSubscription()
        setupUpdatedMessageSubscription()
    }
    
    func setupUISubscriptions() {
        subscribeToSendMessageAction()
        subscribeToSpeechRequest()
        subscribeToMoreMessagesRequest()
        subscribeToClearChatRequest()
    }
}





