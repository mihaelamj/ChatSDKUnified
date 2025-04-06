//
//  Items+Protocols.swift
//  ResChatUIApp
//
//  Created by Mihaela MJ on 02.08.2024..
//

import UIKit
import ResChatHouCommon

class LanguagesPickerDataSource: NSObject, UIPickerViewDataSource {
    let languages: [Language]
    
    init(languages: [Language]) {
        self.languages = languages
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
}

class LanguagesPickerDelegate: NSObject, UIPickerViewDelegate {
    let languages: [Language]
    var didSelectLanguage: ((Language) -> Void)?
    
    init(languages: [Language]) {
        self.languages = languages
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedLanguage = languages[row]
        didSelectLanguage?(selectedLanguage)
        print("selectedLanguage = \(selectedLanguage)")
    }
}


class AirportsSegmentedControlDataSource {
    let airports: [Airport]
    
    init(airports: [Airport]) {
        self.airports = airports
    }
    
    func configureSegmentedControl(_ segmentedControl: UISegmentedControl) {
        segmentedControl.removeAllSegments()
        for (index, airport) in airports.enumerated() {
            segmentedControl.insertSegment(withTitle: airport.name, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }
}

class AirportsSegmentedControlDelegate: NSObject {
    let airports: [Airport]
    
    init(airports: [Airport]) {
        self.airports = airports
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedAirport = airports[sender.selectedSegmentIndex]
        print("selectedAirport = \(selectedAirport), \(selectedAirport.name)")
    }
}
