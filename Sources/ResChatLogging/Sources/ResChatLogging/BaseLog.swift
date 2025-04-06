//
//  BaseLog.swift
//  ResChatUtil
//
//  Created by Mihaela MJ on 22.09.2024..
//

import Foundation
import ResChatUtil

open class BaseLog {
    
    // MARK: Public Typealias -
    
    public typealias LogEntry = [String: Any]
    
    // MARK: Instance Properties -
    
    public var log: [LogEntry] = []
    private let logQueue: DispatchQueue
    
    open var logFileName: String { return "_base_log.json" }
    open var logPrefix: String { return "DBGG: BaseLog->" }
    
    static let debugActive = false
    
#if DEBUG
    public class var active: Bool { return debugActive }
    public class var consoleActive: Bool { return debugActive }
#else
    public class var active: Bool { return false }
    public class var consoleActive: Bool { return false }
#endif
    
    // MARK: Initializer
    public init() {
        // Initialize logQueue with a unique label for each subclass
        let label = "com.ResChat.\(type(of: self))Queue"
        print(label)
        logQueue = DispatchQueue(label: label, attributes: .concurrent)
    }
}

// MARK: Item -

public extension BaseLog {
    
    // MARK: Append Log Entry
    func append(_ logEntry: LogEntry) {
        guard Self.active else { return }

        logQueue.async(flags: .barrier) {
            var modifiedLogEntry = logEntry
            modifiedLogEntry["index"] = self.log.count
            modifiedLogEntry["date"] = Date.loggableCurrentDate()

            self.log.append(modifiedLogEntry)
            self.saveAsJSON()
        }
    }
    
    func logError(name: String, error: Error? = nil) {
        guard Self.active else { return }
        var logEntry: LogEntry = [ "Error" : name]
        if let error = error { logEntry["description"] = error.localizedDescription }
        
        if Self.consoleActive {
            print("\(logPrefix): Error: `\(name)`")
        }
        
        append(logEntry)
    }
}

// MARK: I/O -

public extension BaseLog {

    func saveAsJSON() {
        guard Self.active else { return }
        
        logQueue.async(flags: .barrier) {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let logFileURL = documentsPath.appendingPathComponent(self.logFileName)
            
            // Create a mutable copy of log for potential modifications
            var validLog = self.log

            if !JSONSerialization.isValidJSONObject(self.log) {
                print("\(self.logPrefix): Log is not a valid JSON object")
                
                // Iterate over each log entry to check for invalid JSON objects
                for (index, entry) in validLog.enumerated() {
                    if !JSONSerialization.isValidJSONObject(entry) {
                        print("\(self.logPrefix): Invalid log entry at index \(index): \(entry)")
                        // Replace invalid entry with a placeholder string
                        validLog[index] = ["error": "<INVALID>"]
                    }
                }
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: validLog, options: .prettyPrinted)
                try jsonData.write(to: logFileURL)
//                print("\(self.logPrefix): Successfully wrote log to file.")
            } catch {
                print("\(self.logPrefix): Error saving log: \(error)")
            }
        }
    }
    
    // Thread-safe read access
    func readLog() -> [LogEntry] {
        guard Self.active else { return []}
        
        var logsCopy: [LogEntry] = []
        logQueue.sync {
            logsCopy = self.log
        }
        return logsCopy
    }
    
    func deleteLog() {
        guard Self.active else { return }
        
        // Use the instance-level logQueue to ensure thread safety
        logQueue.async(flags: .barrier) {
            // Clear the in-memory log
            self.log.removeAll()
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let logFileURL = documentsPath.appendingPathComponent(self.logFileName)

            do {
                // Check if the log file exists
                if FileManager.default.fileExists(atPath: logFileURL.path) {
                    // Try removing the log file from disk
                    try FileManager.default.removeItem(at: logFileURL)
                    print("\(self.logPrefix): Deleted log file at: \(logFileURL.absoluteString)")
                } else {
                    // Log if the file doesn't exist
                    print("\(self.logPrefix): Log file does not exist at: \(logFileURL.absoluteString)")
                }
            } catch {
                // Handle any errors that occurred during the file deletion
                print("\(self.logPrefix): Error deleting log file: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: Helper -

public extension BaseLog {
    
    // Helper: Print Pretty-printed JSON array
    func printPrettyJSON(from array: [Any]) {
        if let jsonString = String.prettyPrintedJSON(from: array) {
            print("Pretty-Printed JSON Array: \n\(jsonString)")
        } else {
            print("Failed to serialize array to pretty JSON")
        }
    }
}
