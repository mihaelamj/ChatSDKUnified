//
//  Util.swift
//  
//
//  Created by Mihaela MJ on 01.09.2024..
//

import XCTest

extension XCTestCase {
    
    public enum TestFile: String, CaseIterable {
        case historySapshot = "send_history_snapshot_data"
        case updateHistoryItem = "update_history_item_data"
        case streamMessage1 = "stream_message_data_01"
        case streamMessage2 = "stream_message_data_461"
        case streamMessage3 = "stream_message_data_1251"
        
        static let folderName = "DemoData"
        
        func loadString() -> String? {
            let result = XCTestCase.loadJSONFromFile(named: rawValue)
            return result
        }
        
        public static var folderPath: String? {
          Bundle.module.path(forResource: folderName, ofType: nil)
        }
    }
    
    static func loadJSONFromFile(named fileName: String, fileExtension: String = "json") -> String? {
        guard let folderPath = TestFile.folderPath else {
            XCTFail("Unable to find the folder path for \(TestFile.folderName) in the test bundle.")
            return nil
        }
        
        let filePath = (folderPath as NSString).appendingPathComponent("\(fileName).\(fileExtension)")
        let fileURL = URL(fileURLWithPath: filePath)
        
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: fileURL.path) else {
            XCTFail("File does not exist at path: \(fileURL.path)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return String(data: data, encoding: .utf8)
        } catch {
            XCTFail("Failed to load \(fileName).\(fileExtension): \(error)")
            return nil
        }
    }
}

class TestFileTests: XCTestCase {
    
    func testLoading() {
        for file in TestFile.allCases {
            print(file)
            guard let fileString = file.loadString() else {
                print("Error loading: \(file)")
                continue
            }
            print(fileString)
        }
    }
}
