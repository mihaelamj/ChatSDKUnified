import Foundation

struct HistoryPayloadIterator: IteratorProtocol {
    private var anyArray: [Any]
    private var currentIndex = 0
    private var messageIndex = 0
    
    init(anyArray: [Any]) {
        self.anyArray = anyArray
    }
    
    mutating func next() -> (index: Int, messageIndex: Int, text: String)? {
        while currentIndex < anyArray.count {
            if let itemDict = anyArray[currentIndex] as? [String: Any] {
                // Check for 'history_snapshot' key
                if let historySnapshot = itemDict["history_snapshot"] as? [String: Any],
                   let messages = historySnapshot["messages"] as? [[String: Any]] {
                    
                    while messageIndex < messages.count {
                        if let payloadString = messages[messageIndex]["payload"] as? String {
                            if let text = extractText(from: payloadString) {
                                defer { messageIndex += 1 } // Move to the next message after returning the current one
                                return (index: currentIndex, messageIndex: messageIndex, text: text)
                            }
                        }
                        messageIndex += 1
                    }
                }
            }
            currentIndex += 1
            messageIndex = 0
        }
        return nil
    }
    
    mutating func updateCurrentText(with newText: String) {
        if currentIndex < anyArray.count {
            if var itemDict = anyArray[currentIndex] as? [String: Any] {
                // Update text in 'history_snapshot' -> 'messages'
                if var historySnapshot = itemDict["history_snapshot"] as? [String: Any],
                   var messages = historySnapshot["messages"] as? [[String: Any]],
                   messageIndex > 0, messageIndex <= messages.count {
                    
                    if let payloadString = messages[messageIndex - 1]["payload"] as? String {
                        if let newPayloadString = updateText(in: payloadString, with: newText) {
                            messages[messageIndex - 1]["payload"] = newPayloadString
                            historySnapshot["messages"] = messages
                            itemDict["history_snapshot"] = historySnapshot
                            anyArray[currentIndex] = itemDict
                        }
                    }
                }
            }
        }
    }
    
    func getUpdatedArray() -> [Any] {
        return anyArray
    }
    
    private func extractText(from payloadString: String) -> String? {
        if let textRange = payloadString.range(of: "\"text\": \"") {
            let startIndex = textRange.upperBound
            if let endIndex = findEndOfText(from: payloadString, startingAt: startIndex) {
                return String(payloadString[startIndex..<endIndex])
            }
        }
        return nil
    }
    
    private func findEndOfText(from payloadString: String, startingAt startIndex: String.Index) -> String.Index? {
        var isEscaped = false
        var index = startIndex
        
        while index < payloadString.endIndex {
            let character = payloadString[index]
            if character == "\\" {
                isEscaped.toggle()
            } else if character == "\"" && !isEscaped {
                // Check if the next character is either }], or a comma, or another key
                let nextIndex = payloadString.index(after: index)
                if nextIndex < payloadString.endIndex {
                    let nextCharacter = payloadString[nextIndex]
                    if nextCharacter == "," || nextCharacter == "}" || nextCharacter == "]" || nextCharacter == "\\" {
                        return index
                    }
                } else {
                    return index
                }
            } else {
                isEscaped = false
            }
            index = payloadString.index(after: index)
        }
        
        return nil
    }
    
    private func updateText(in payloadString: String, with newText: String) -> String? {
        if let textRange = payloadString.range(of: "\"text\": \"") {
            let startIndex = textRange.upperBound
            if let endIndex = findEndOfText(from: payloadString, startingAt: startIndex) {
                let newPayloadString = String(payloadString[..<startIndex]) + newText + String(payloadString[endIndex...])
                return newPayloadString
            }
        }
        return nil
    }
}

