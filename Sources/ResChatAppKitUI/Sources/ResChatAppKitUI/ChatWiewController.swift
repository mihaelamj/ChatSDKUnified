//
//  ChatWindowController.swift
//  ResChatAppKitUI
//
//  Created by Mihaela MJ on 17.09.2024..
//
#if os(macOS)
import AppKit
import Combine
import ResChatAppearance
import ResChatProtocols
import ResChatAttributedText
import ResChatUICommon
import ResChatSpeech
import ResChatMessageManager

open class ChatViewController: PlatformViewController {
    
    enum ScrollPosition {
        case top
        case bottom
    }
    
    // MARK: Socket Proxy -
    
//    public var proxy: UIDataSource? {
//        didSet {
//            subscribeToProxyPublishers()
//        }
//    }
    
    internal var cancellables = Set<AnyCancellable>()
    
    // MARK: My Publishers -
    
    internal let didTapSendUserMessageSubject = PassthroughSubject<String, Never>()
    internal let didTapSpeechButtonSubject = PassthroughSubject<Void, Never>()
    internal let didRequestMoreMessagesSubject = PassthroughSubject<Void, Never>()
    internal let didRequestToClearChatSubject = PassthroughSubject<Void, Never>()
    
    internal var scrollPositionSubject = PassthroughSubject<ScrollPosition, Never>()
    
//    var messageHandler: MessageHandlingAlgorithm = OptimizedStreamingAlgorithm()
    
    // MARK: Cell Classes -
    
    open class var userMessageCellType: UserMessageCell.Type {
        UserMessageCell.self
    }
    open class var chatBotMessageCellType: ChatBotMessageCell.Type {
        ChatBotMessageCell.self
    }
    open class var loadingMessageCellType: LoadingTableViewCell.Type {
        LoadingTableViewCell.self
    }
    
    // MARK: UI Elements -
    
    lazy var tableView: NSTableView = {
        let tableView = NSTableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = colorProvider.backgroundColor
        return tableView
    }()
    
    lazy var dataSource: UIMessageDataSource = {
        return UIMessageDataSource(
            tableView: tableView,
            userMessageCellType: Self.userMessageCellType,
            botMessageCellType: Self.chatBotMessageCellType,
            loadingMessageCellType: Self.loadingMessageCellType
        )
    }()
    
    let loadingIndicator = NSProgressIndicator()
    
    // MARK: Properties -
    
    let isDemo = false
    var didRequestToClearChat = false
    
    private var imageProvider: ResChatAppearance.ImageProviding
    private var colorProvider: ResChatAppearance.ColorProviding
    private var speechRecognizer: SpeechRecognizerProtocol?
    
    // MARK: UI Elements -
    
    lazy var messageTextField: NSTextField = {
        let textField = NSTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholderString = "Type your question here..."
        return textField
    }()
    
    private lazy var sendButton: NSButton = {
        let button = NSButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = "Send"
        button.target = self
        button.action = #selector(sendMessage)
        return button
    }()
    
    private lazy var messageInputContainer: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
        view.addSubview(messageTextField)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            messageTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    
    // MARK: Init -
    
    public init(imageProvider: ImageProviding? = nil,
                colorProvider: ColorProviding? = nil,
                speechRecognizer: SpeechRecognizerProtocol? = nil) {
        self.imageProvider = imageProvider ?? ResChatAppearance.DefaultImageProvider()
        self.colorProvider = colorProvider ?? ResChatAppearance.DefaultColorProvider()
        self.speechRecognizer = speechRecognizer
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AttributedTextCache.shared.clearCache()
    }
    
    // MARK: Lifecycle -
    
    public override func loadView() {
        self.view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = colorProvider.backgroundColor.cgColor
        
        setupTableView()
        setupMessageInputContainer()
        setupLoadingIndicator()
    }
    
    // MARK: Setup UI -
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor)
        ])
    }
    
    private func setupMessageInputContainer() {
        view.addSubview(messageInputContainer)
        
        NSLayoutConstraint.activate([
            messageInputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messageInputContainer.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.isDisplayedWhenStopped = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: Data Management -
    
    private func configureDataSource() {
//        _ = dataSource  This triggers the lazy initialization of `dataSource`
    }
    
    private func applyInitialDemoSnapshot() {
//        dataSource.applyInitialSnapshot(messages: initialDemoMessages())
    }
    
    // MARK: Actions -
    
    @objc private func sendMessage() {
        guard !messageTextField.stringValue.isEmpty else { return }
        
        sendUserMessage(messageTextField.stringValue)
    }
    
    private func sendUserMessage(_ text: String) {
        // Logic for sending user message
    }
    
    private func sendChatbotMessage(_ text: String) {
        // Logic for sending chatbot message
    }
    
    // MARK: Loading Indicator -
    
    func showLoadingIndicator() {
        loadingIndicator.startAnimation(nil)
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimation(nil)
    }
}

// MARK: Demo Messages -

private extension ChatViewController {
    
    func initialDemoMessages() -> [UIMessage] {
        return [
            UIMessage.newChatBotTextCell("Hi, I am your personal Airport Assistant. Type any questions you wish me to help with regarding Airport information such as Travel & Flights, Terminal maps or any Visitor information that you might want to know."),
            UIMessage.newUserTextCell("Hello"),
            UIMessage.newChatBotTextCell("Hello, please ask anything you wish to know about the airport."),
            UIMessage.newUserTextCell("Can you tell me about the available terminals?"),
            UIMessage.newChatBotTextCell("Sure! We have Terminal 1, Terminal 2, and Terminal 3. Which one do you need information about?")
        ]
    }
}
#endif
