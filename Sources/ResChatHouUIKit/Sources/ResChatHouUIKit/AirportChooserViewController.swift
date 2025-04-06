//
//  AirportChooserViewController.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 02.08.2024..
//

import UIKit
import ResChatHouCommon
import ResChatProtocols

public class AirportChooserViewController: PlatformViewController {

    // MARK: Properties -
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let titleLabel = UILabel()
    let airportLabel = UILabel()
    let airportSegmentedControl = UISegmentedControl(items: Airport.allCases.map { $0.name })
    let languageLabel = UILabel()
    let languagePicker = UIPickerView()
    let chooseButton = UIButton(type: .system)
    
//    public weak var delegate: AirportAndLanguageChooserDelegate?
    
    let airports: [Airport]
    let languages: [Language]
    
    let languagesPickerDataSource: LanguagesPickerDataSource
    let languagesPickerDelegate: LanguagesPickerDelegate
    let airportsSegmentedControlDataSource: AirportsSegmentedControlDataSource
    let airportsSegmentedControlDelegate: AirportsSegmentedControlDelegate
    
    var selectedAirport: Airport {
        return airports[airportSegmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment
                            ? airportSegmentedControl.selectedSegmentIndex
                            : 0]
    }
    
    var selectedLanguage: Language {
        return languages[languagePicker.selectedRow(inComponent: 0)]
    }
    
    // MARK: Init -
    
    required init(airports: [Airport] = Airport.allCases, languages: [Language] = Language.allCases) {
        self.airports = airports
        self.languages = languages
        
        self.languagesPickerDataSource = LanguagesPickerDataSource(languages: languages)
        self.languagesPickerDelegate = LanguagesPickerDelegate(languages: languages)
        
        self.airportsSegmentedControlDataSource = AirportsSegmentedControlDataSource(airports: airports)
        self.airportsSegmentedControlDelegate = AirportsSegmentedControlDelegate(airports: airports)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle -
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        setupScrollView()
        setupViews()
        
        // Set up data sources and delegates
        airportsSegmentedControlDataSource.configureSegmentedControl(airportSegmentedControl)
        
        airportSegmentedControl.addTarget(airportsSegmentedControlDelegate,
                                          action: #selector(airportsSegmentedControlDelegate.segmentedControlValueChanged(_:)),
                                          for: .valueChanged)
        languagePicker.dataSource = languagesPickerDataSource
        languagePicker.delegate = languagesPickerDelegate
    }
    
    // MARK: Setup Views -
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupViews() {
        // Add all views to contentView
        contentView.addSubview(titleLabel)
        contentView.addSubview(airportLabel)
        contentView.addSubview(airportSegmentedControl)
        contentView.addSubview(languageLabel)
        contentView.addSubview(languagePicker)
        contentView.addSubview(chooseButton)
        
        setupTitleLabel()
        setupAirportLabel()
        setupSegmentedControl()
        setupLanguageLabel()
        setupPicker()
        setupButton()
        
        layoutViews()
    }
    
    // MARK: Actions -
    
    @objc func chooseButtonTapped() {
        print("Selected Airport: \(selectedAirport), \(selectedAirport.name), and Language: \(selectedLanguage)")
        handleSelection(airport: selectedAirport, language: selectedLanguage)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedAirport = airports[sender.selectedSegmentIndex]
        print("Selected Airport: \(selectedAirport)")
    }
}

// MARK: Setup -

private extension AirportChooserViewController {
    func setupTitleLabel() {
        titleLabel.text = NSLocalizedString("configure_your_chat", 
                                            value: "Configure your chat",
                                            comment: "Title for the chat configuration screen")
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.label  // Adapts to light/dark mode
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupAirportLabel() {
        airportLabel.text = NSLocalizedString("choose_airport_prompt", 
                                              value: "Which airport would you like assistance with?",
                                              comment: "Prompt asking the user to choose an airport")
        airportLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        airportLabel.textColor = UIColor.label  // Adapts to light/dark mode
        airportLabel.numberOfLines = 0
        airportLabel.textAlignment = .center
        airportLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupSegmentedControl() {
        airportSegmentedControl.selectedSegmentIndex = 0
        airportSegmentedControl.backgroundColor = UIColor.secondarySystemBackground  // Adapts to light/dark mode
        airportSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLanguageLabel() {
        languageLabel.text = NSLocalizedString("select_language", 
                                               value: "Select preferred language",
                                               comment: "Label for selecting preferred language")
        languageLabel.font = UIFont.systemFont(ofSize: 18)
        languageLabel.textColor = UIColor.label  // Adapts to light/dark mode
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupPicker() {
        languagePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupButton() {
        chooseButton.setTitle(NSLocalizedString("choose_button", 
                                                value: "Choose",
                                                comment: "Button to confirm selection of airport and language"),
                              for: .normal)
        chooseButton.backgroundColor = .systemBlue
        chooseButton.setTitleColor(.systemBackground, for: .normal)
        chooseButton.layer.cornerRadius = 10
        chooseButton.addTarget(self, action: #selector(chooseButtonTapped), for: .touchUpInside)
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: Layout -

private extension AirportChooserViewController {
    func layoutViews() {
        NSLayoutConstraint.activate([
            // Layout for title label
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
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



