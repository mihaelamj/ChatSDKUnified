//
//  File.swift
//  ResChatHouAppKit
//
//  Created by Mihaela MJ on 17.09.2024..
//

import AppKit
import ResChatHouCommon
import ResChatProtocols

public class AirportChooserViewController: PlatformViewController {
    
    // MARK: Properties -
    
    let scrollView = NSScrollView()
    let contentView = NSView()
    
    let titleLabel = NSTextField(labelWithString: NSLocalizedString("configure_your_chat",
                                                                    value: "Configure your chat",
                                                                    comment: "Title for the chat configuration screen"))
    let airportLabel = NSTextField(labelWithString: NSLocalizedString("choose_airport_prompt",
                                                                      value: "Which airport would you like assistance with?",
                                                                      comment: "Prompt asking the user to choose an airport"))
    
    let airportSegmentedControl = NSSegmentedControl(labels: Airport.allCases.map { $0.name },
                                                     trackingMode: .selectOne,
                                                     target: self,
                                                     action: #selector(airportSegmentedControlChanged(_:)))
    let languageLabel = NSTextField(labelWithString: NSLocalizedString("select_language",
                                                                       value: "Select preferred language",
                                                                       comment: "Label for selecting preferred language"))
    let languagePicker = NSPopUpButton()
    let chooseButton = NSButton(title: NSLocalizedString("choose_button",
                                                         value: "Choose",
                                                         comment: "Button to confirm selection of airport and language"),
                                target: self,
                                action: #selector(chooseButtonTapped))
    
    public weak var delegate: AirportAndLanguageChooserDelegate?
    
    let airports: [Airport]
    let languages: [Language]
    
    var selectedAirport: Airport {
        return airports[airportSegmentedControl.selectedSegment != -1
                            ? airportSegmentedControl.selectedSegment
                            : 0]
    }
    
    var selectedLanguage: Language {
        let selectedIndex = languagePicker.indexOfSelectedItem
        return languages.indices.contains(selectedIndex) ? languages[selectedIndex] : languages.first ?? .english
    }
    
    
    // MARK: Init -
    
    required init(airports: [Airport] = Airport.allCases, languages: [Language] = Language.allCases) {
        self.airports = airports
        self.languages = languages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle -
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
        setupScrollView()
        setupViews()
        
        // Set up language picker
        languagePicker.addItems(withTitles: languages.map { $0.rawValue })
        languagePicker.selectItem(at: 0)
    }
    
    // MARK: Setup Views -
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.documentView = contentView
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(airportLabel)
        contentView.addSubview(airportSegmentedControl)
        contentView.addSubview(languageLabel)
        contentView.addSubview(languagePicker)
        contentView.addSubview(chooseButton)
        
        setupButton()
        layoutViews()
    }
    
    // MARK: Actions -
    
    @objc func chooseButtonTapped() {
        print("Selected Airport: \(selectedAirport), and Language: \(selectedLanguage)")
        handleSelection(airport: selectedAirport, language: selectedLanguage)
    }
    
    @objc func airportSegmentedControlChanged(_ sender: NSSegmentedControl) {
        let selectedAirport = airports[sender.selectedSegment]
        print("Selected Airport: \(selectedAirport)")
    }
}

// MARK: Setup -

private extension AirportChooserViewController {
    
    func setupButton() {
        chooseButton.target = self
        chooseButton.action = #selector(chooseButtonTapped)
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: Layout -

private extension AirportChooserViewController {
    
    func layoutViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        airportLabel.translatesAutoresizingMaskIntoConstraints = false
        airportSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languagePicker.translatesAutoresizingMaskIntoConstraints = false
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Layout for title label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Layout for airport label
            airportLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            airportLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            airportLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Layout for airport segmented control
            airportSegmentedControl.topAnchor.constraint(equalTo: airportLabel.bottomAnchor, constant: 10),
            airportSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            airportSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Layout for language label
            languageLabel.topAnchor.constraint(equalTo: airportSegmentedControl.bottomAnchor, constant: 20),
            languageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            languageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Layout for language picker
            languagePicker.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 10),
            languagePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            languagePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            languagePicker.heightAnchor.constraint(equalToConstant: 150),
            
            // Layout for choose button
            chooseButton.topAnchor.constraint(equalTo: languagePicker.bottomAnchor, constant: 20),
            chooseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            chooseButton.heightAnchor.constraint(equalToConstant: 50),
            chooseButton.widthAnchor.constraint(equalToConstant: 200),
            chooseButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Bottom anchor to enable scrolling
        ])
    }
}

public extension AirportChooserViewController {
    override class func make() -> Self {
        return Self.init(airports: Airport.allCases, languages: Language.allCases)
    }
}
