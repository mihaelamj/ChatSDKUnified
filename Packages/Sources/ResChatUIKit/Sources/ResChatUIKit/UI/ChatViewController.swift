//
//  ChatViewController.swift
//  
//
//  Created by Mihaela MJ on 21.05.2024..
//

import UIKit
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
    
    internal var cancellables = Set<AnyCancellable>()
    
    // MARK: My Publishers -
    
    // Combine subjects for each event
    internal let didTapSendUserMessageSubject = PassthroughSubject<String, Never>()
    internal let didTapSpeechButtonSubject = PassthroughSubject<Void, Never>()
    internal let didRequestMoreMessagesSubject = PassthroughSubject<Void, Never>()
    internal let didRequestToClearChatSubject = PassthroughSubject<Void, Never>()
    internal let hasMoreMessagesToLoadSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Internal Listeres -
    
    // Listener for scroll position events
    internal var scrollPositionSubject = PassthroughSubject<ScrollPosition, Never>()
    internal var hasScrolledToTop = false
    internal var hasScrolledToBottom = false
    
    private func subscribeToScrollViewPosition() {
        // Subscribe to scroll position updates
        scrollPositionSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] position in
                switch position {
                case .top:
                    self?.handleScrolledToTop()
                case .bottom:
                    self?.handleScrolledToBottom()
                }
            }
            .store(in: &cancellables)
    }
    
    var messageManager: UIMessageManager! = nil
    var currentSnapshot: UIMessageSnapshot! = nil
    
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
    
    // MARK: Collection Properties -
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.backgroundColor = colorProvider.backgroundColor
        AttributedTextCache.shared.clearCache()
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
    
    // MARK: Loading View -
    
    let loadingView = UIActivityIndicatorView(style: .large)
    
    // MARK: Properties -
    
    let isDemo = false
    var didRequestToClearChat = false
    private var speechRecognizer: SpeechRecognizerProtocol?
    
    // MARK: Providers -
    
    internal var imageProvider: ResChatAppearance.ImageProviding
    internal var colorProvider: ResChatAppearance.ColorProviding
    public var navigationBarProvider: ResChatAppearance.NavigationBarProviding?
    
    // MARK: UI Properties -
    
    internal let usesTextView = false
    internal var isSendingEnabled = true {
        didSet {
            if oldValue != isSendingEnabled {
                print("`isSendingEnabled` Value changed from \(oldValue) to \(isSendingEnabled)")
                setUserActionsEnabled(isSendingEnabled)
            }
        }
    }
    
    internal var currentBotID: String? = nil {
        didSet {
            // Check for transition from nil to String or String to nil
            if (oldValue == nil && currentBotID != nil) || (oldValue != nil && currentBotID == nil) {
                if let currentBotID {
                    if oldValue == nil {  // nil -> String
                        print("`currentBotID` Value changed from `nil` to \(currentBotID)")
                        notifyBotStartedTyping()
                    }
                } else {
                    if oldValue != nil { // String -> nil
                        print("`currentBotID` Value changed from \(oldValue!) to `nil`")
                        notifyBotFinishedTyping()
                    }
                }
            } else if oldValue != nil && currentBotID != nil && oldValue != currentBotID {
                // This is a String-to-String transition
                print("String-to-String transition from \(oldValue!) to \(currentBotID!) - Ignored or handle as needed")
            }
        }
    }
    
    internal lazy var placeholderAttributes: [NSAttributedString.Key: Any] =  {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: colorProvider.placeholderMessageTextColor,
            .font: UIFont.inputPlaceholder
        ]
        return attributes
    }()
    
    internal let placeholderText = "Type your question here..."
    
    private var messageInputContainerBottomConstraint: NSLayoutConstraint?
    
    lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)

//        textField.textColor = .label
        textField.textColor = colorProvider.messageTextColor
        textField.delegate = self
//        textField.backgroundColor = .systemBackground
        textField.backgroundColor = colorProvider.backgroundColor
        return textField
    }()
    
    lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
//        textView.backgroundColor = .systemBackground
        textView.backgroundColor = colorProvider.backgroundColor
        
        textView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        
//        textView.textColor = .label
        textView.textColor = colorProvider.messageTextColor
        textView.layer.cornerRadius = LayoutConstants.messageTextFieldHeight / 2.0
        textView.delegate = self
        
        textView.setPlaceholder(placeholderText, attributes: placeholderAttributes)
        return textView
    }()
    
    internal lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let sendButtonImage = imageProvider.sendIcon
        button.setImage(sendButtonImage, for: .normal)
        button.tintColor = .systemBlue //colorProvider.sendIconColor
        button.tintColor = colorProvider.sendIconColor
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    private lazy var microphoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(microphoneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pillHolderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemBackground
        view.backgroundColor = colorProvider.backgroundColor
//        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderColor = colorProvider.inputBorderColor.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = LayoutConstants.messageTextFieldHeight / 2.0  // 1/2 of the height
        
        if usesTextView {
            
            view.addSubview(messageTextView)
            view.addSubview(sendButton)

            NSLayoutConstraint.activate([
                sendButton.widthAnchor.constraint(equalToConstant: LayoutConstants.sendButtonSide),
                sendButton.heightAnchor.constraint(equalToConstant: LayoutConstants.sendButtonSide),
                sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.sendButtonTrailing),
                
                messageTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.inputTextLeading),
                messageTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                messageTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -LayoutConstants.inputTextTrailing),
                messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: LayoutConstants.minTextViewHeight)
            ])
            
        } else {
            
            view.addSubview(messageTextField)
            view.addSubview(sendButton)
            
            NSLayoutConstraint.activate([
                sendButton.widthAnchor.constraint(equalToConstant: LayoutConstants.sendButtonSide),
                sendButton.heightAnchor.constraint(equalToConstant: LayoutConstants.sendButtonSide),
                sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.sendButtonTrailing),
                
                messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.inputTextLeading),
                messageTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -LayoutConstants.inputTextTrailing)
            ])
        }
        return view
    }()
        
    private lazy var messageInputContainerView: UIView = {
        let aView = UIView()
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.backgroundColor = .systemBackground
        aView.layer.shadowColor = UIColor.black.cgColor
        aView.layer.shadowOpacity = 0.1
        aView.layer.shadowOffset = CGSize(width: 0, height: -2)
        aView.layer.shadowRadius = 2
        
        aView.addSubview(pillHolderView)
        let withMicrophone = speechRecognizer != nil
        
        if withMicrophone {
            aView.addSubview(microphoneButton)
            
            NSLayoutConstraint.activate([
                
                microphoneButton.widthAnchor.constraint(equalToConstant: LayoutConstants.microphoneButtonSide),
                microphoneButton.heightAnchor.constraint(equalToConstant: LayoutConstants.microphoneButtonSide),
                microphoneButton.centerYAnchor.constraint(equalTo: aView.centerYAnchor),
                microphoneButton.leadingAnchor.constraint(equalTo: aView.leadingAnchor, constant: LayoutConstants.inputPillLeading),
                
                pillHolderView.leadingAnchor.constraint(equalTo: microphoneButton.trailingAnchor, constant: LayoutConstants.microphoneButtonTrailing),
                pillHolderView.trailingAnchor.constraint(equalTo: aView.trailingAnchor, constant: -LayoutConstants.inputPillTrailing),
                pillHolderView.centerYAnchor.constraint(equalTo: aView.centerYAnchor),
                pillHolderView.heightAnchor.constraint(equalToConstant: LayoutConstants.messageTextFieldHeight)
            ])
            
        } else {
            NSLayoutConstraint.activate([
                pillHolderView.leadingAnchor.constraint(equalTo: aView.leadingAnchor, constant: LayoutConstants.inputPillLeading),
                pillHolderView.trailingAnchor.constraint(equalTo: aView.trailingAnchor, constant: -LayoutConstants.inputPillTrailing),
                pillHolderView.centerYAnchor.constraint(equalTo: aView.centerYAnchor),
                pillHolderView.heightAnchor.constraint(equalToConstant: LayoutConstants.messageTextFieldHeight)
            ])
        }
        
        aView.accessibilityIdentifier = "messageInputContainerView"
        return aView
    }()
        
    // MARK: Init -
    
    public init(imageProvider: ImageProviding? = nil,
                colorProvider: ColorProviding? = nil,
                speechRecognizer: SpeechRecognizerProtocol? = nil) {
        
        UILog.shared.deleteLog()
        ResChatMessageManager.ProcessLog.shared.deleteLog()
        
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
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Lifecycle -

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = colorProvider.backgroundColor
        navigationController?.delegate = self
        customizeNavigationBarAppearance()
        
        setupTableView()
        configureDataSource()
        regiserTableCells()
        
        if isDemo {
            applyInitialDemoSnapshot()
        }
        
        setupMessageInputContainer()
        setupKeyboard()
        setupLoadingView()
        
        setupSpeechRecognizer()
        
        subscribeToScrollViewPosition()
        
        // subscribeToNotifications()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: UI Setup -
    
    private func configureDataSource() {
        // init message manager
        
        self.messageManager = UIMessageManager { [weak self] (manager: UIMessageManager) in
            guard let self = self else { return }
//            self.updateUI(animated: true)
        }
        
        _ = dataSource // This triggers the lazy initialization of `dataSource`
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) // Adjusted to respect safe area
        ])
    }
    
    private func setupMessageInputContainer() {
        view.addSubview(messageInputContainerView)
        
        messageInputContainerBottomConstraint = messageInputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            messageInputContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            messageInputContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            messageInputContainerBottomConstraint!,
            messageInputContainerView.heightAnchor.constraint(equalToConstant: LayoutConstants.messageInputContainerViewHeight)  // Explicit height
        ])
        
        setupNoKeyboardTableViewContentInset()
    }
    
    // MARK: Loading View -
    
    private func setupLoadingView() {
        loadingView.center = view.center
        view.addSubview(loadingView)
        
        // Disable user interaction so touches pass through the loading view
        loadingView.isUserInteractionEnabled = false
        
        // Initially hide the loading indicator
        loadingView.isHidden = true
    }
    
    // Show the loading indicator on command
    func showLoadingIndicator() {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    // Hide the loading indicator on command
    func hideLoadingIndicator() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }
    
    // MARK: Setup UI -
    
    private func setupNoKeyboardTableViewContentInset() {
        setupTableViewContentInsetBottom(LayoutConstants.messageInputContainerViewHeight)
    }
    
    private func setupTableViewContentInsetBottom(_ bottom: CGFloat) {
        // Adjust table view content inset
        var contentInset = tableView.contentInset
        contentInset.bottom = bottom
        tableView.contentInset = contentInset
        
        // Adjust table view scroll indicator inset
        var scrollIndicatorInsets = tableView.scrollIndicatorInsets
        scrollIndicatorInsets.bottom = bottom
        tableView.scrollIndicatorInsets = scrollIndicatorInsets
    }
    
    private func setupMicrophoneButton() {
        if speechRecognizer != nil {
            microphoneButton.isEnabled = true
            microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        } else {
            microphoneButton.isEnabled = false
            microphoneButton.setImage(nil, for: .normal)
        }
    }
    
    private func updateMicrophoneButton(authorized: Bool) {
        if authorized {
            microphoneButton.isEnabled = true
            microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        } else {
            microphoneButton.isEnabled = false
            microphoneButton.setImage(nil, for: .normal)
        }
    }
    
    private func customizeNavigationBarAppearance() {
        guard let navigationBarProvider = navigationBarProvider else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = navigationBarProvider.backgroundColor
        appearance.titleTextAttributes = [
            .foregroundColor: navigationBarProvider.textColor,
            .font: navigationBarProvider.font
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = navigationBarProvider.title
        
        if let rightButtonImage = navigationBarProvider.rightButtonImage {
            let rightButton = UIBarButtonItem(
                image: rightButtonImage,
                style: .plain,
                target: self,
                action: #selector(rightButtonTapped)
            )
            rightButton.tintColor = navigationBarProvider.textColor 
            navigationItem.rightBarButtonItem = rightButton
        }
        
        if let leftButtonImage = navigationBarProvider.backButtonImage {
            let leftButton = UIBarButtonItem(
                image: leftButtonImage,
                style: .plain,
                target: self,
                action: #selector(leftButtonTapped)
            )
            leftButton.tintColor = navigationBarProvider.textColor
            navigationItem.leftBarButtonItem = leftButton
        }
    }
    
    // MARK: Speech Setup -
    
    private func setupSpeechRecognizer() {
        setupMicrophoneButton()
        setupNotificationObservers()
        
        // Request speech recognition authorization
        speechRecognizer?.requestAuthorization { authorized in
            DispatchQueue.main.async {
                self.updateMicrophoneButton(authorized: authorized)
                if authorized {
                    print("Speech recognition authorized")
                } else {
                    print("Speech recognition authorization denied")
                }
            }
        }
        
        // Set up text recognition callback
        speechRecognizer?.onTextRecognized = { [weak self] recognizedText in
            self?.messageTextField.text = recognizedText
        }
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidStartRecording), name: .didStartRecording, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidFinishRecording), name: .didFinishRecording, object: nil)
    }
    
    @objc private func handleDidStartRecording() {
        microphoneButton.isEnabled = true
        sendButton.isEnabled = false
        microphoneButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
    }
    
    @objc private func handleDidFinishRecording() {
        microphoneButton.isEnabled = true
        microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        sendMessage()
        sendButton.isEnabled = true
    }

    // MARK: Data Setup -
    
    private func regiserTableCells() {
        tableView.register(Self.userMessageCellType, forCellReuseIdentifier: Self.userMessageCellType.identifier)
        tableView.register(Self.chatBotMessageCellType, forCellReuseIdentifier: Self.chatBotMessageCellType.identifier)
        tableView.register(Self.loadingMessageCellType, forCellReuseIdentifier: Self.loadingMessageCellType.identifier)
    }
    
    private func applyInitialDemoSnapshot() {
        dataSource.applyInitialSnapshot(messages: initialDemoMessages())
    }
    
    // MARK: Actions -
    
    @objc private func microphoneButtonTapped() {
        DispatchQueue.main.async { [self] in
            speechButtonAction()
            do {
                if let isRunning = speechRecognizer?.isRunning, isRunning {
                    print("STOP")
                    speechRecognizer?.stopRecording()
                    microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
                } else {
                    print("REC")
                    try speechRecognizer?.startRecording()
                    microphoneButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                }
            } catch {
                print("There was a problem starting the speech recognizer: \(error)")
            }
        }
    }
}


// MARK: Adding Text Messages -

internal extension ChatViewController {
    
    func addUserChatText(_ text: String) {
        let newMessage = UIMessage.newUserTextCell(text)
        var snapshot = dataSource.snapshot()
        
        // Ensure the section exists before adding items
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        
        snapshot.appendItems([newMessage], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        messageTextField.text = ""
        scrollToBottom()
    }
    
    func addChatbotChatText(_ text: String) {
        let newMessage = UIMessage.newChatBotTextCell(text)
        var snapshot = dataSource.snapshot()
        
        // Ensure the section exists before adding items
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        
        snapshot.appendItems([newMessage], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        scrollToBottom()
    }
}


// MARK: Message Actions -

internal extension ChatViewController {
    
    @objc func sendMessage() {
        if usesTextView {
            sendTextViewMessage()
        } else {
            sendTextFieldMessage()
        }
    }
    
    func sendTextFieldMessage() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        sendUserMessage(text)
    }
    
    func sendTextViewMessage() {
        guard let text = messageTextView.text, !text.isEmpty, text != placeholderText else { return }
        sendUserMessage(text)
        messageTextView.text = ""
        // Restore the placeholder after sending
        messageTextView.setPlaceholder(placeholderText, attributes: placeholderAttributes)
    }
    
// INFO: Called from `sendUserMessage` -
    func sendChatMessage(_ message: String) {
        dismissKeyboard()
        if isDemo {
            sendUIText(with: message)
        } else {
            sendUIMessage(message)
        }
    }
}

// MARK: Public Actions -

public extension ChatViewController {
    @objc func rightButtonTapped() {
        print("right button tapped")
        didRequestToClearChatSubject.send(())
        didRequestToClearChat = true
    }
    
    @objc open func leftButtonTapped() {}
}


// MARK: Keyboard -

extension ChatViewController {
    
    func scrollToBottom() {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        // Ensure there is at least one row to scroll to
        guard numberOfRows > 0 else { return }
        
        let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func scrollToTop() {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        // Ensure there is at least one row to scroll to
        guard numberOfRows > 0 else { return }
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func setupKeyboard() {
        setupKeyboardObservers()
        setupKeyboardTap()
    }
    
    private func setupKeyboardTap() {
        // Dismiss keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            
            let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            
            // Adjust table view content inset and scroll indicator inset
            setupTableViewContentInsetBottom(keyboardHeight + LayoutConstants.messageInputContainerViewHeight)
            
            // Adjust message input container view bottom constraint
            messageInputContainerBottomConstraint?.constant = -keyboardHeight
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
                self.scrollToBottom()
            }
        }
    }

    @objc private func handleKeyboardWillHide(notification: Notification) {
        if let userInfo = notification.userInfo,
           let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            
            // Reset table view content inset and scroll indicator inset
            setupNoKeyboardTableViewContentInset()
            
            // Reset message input container view bottom constraint
            messageInputContainerBottomConstraint?.constant = 0
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return LayoutConstants.invisibleFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected item
        if let selectedMessage = dataSource.itemIdentifier(for: indexPath) {
            // Handle the selection
            print("Selected message: \(selectedMessage.text)")
            
            // Perform any additional actions here, like navigating to another screen or updating the UI
        }
        
        // Deselect the row after selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    // Add UITextFieldDelegate methods if needed
}

// MARK: UINavigationControllerDelegate -

extension ChatViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if let chatVC = viewController as? ChatViewController {
            chatVC.customizeNavigationBarAppearance()
        }
    }
}


// MARK: Demo Messages -

private extension ChatViewController {
    
    func initialDemoMessages() -> [UIMessage] {
        return [
            UIMessage.newChatBotTextCell("Hi, I am your personal Airport Assistant. Type any questions you wish me to help with regarding Airport information such as Travel & Flights, Terminal maps or any Visitor information that you might want to know."),
            UIMessage.newUserTextCell("Hello"),
            UIMessage.newChatBotTextCell( "Hello, please ask anything you wish to know about the airport."),
            UIMessage.newUserTextCell("Can you tell me about the available terminals?"),
            UIMessage.newChatBotTextCell( "Sure! We have Terminal 1, Terminal 2, and Terminal 3. Which one do you need information about?"),
        ]
    }
    
}



