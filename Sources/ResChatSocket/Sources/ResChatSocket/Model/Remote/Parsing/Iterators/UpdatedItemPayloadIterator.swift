
import Foundation

struct UpdatedItemPayloadIterator: IteratorProtocol {
    private var anyArray: [Any]
    private var currentIndex = 0
    private var messageIndex = 0
    private let payloadHandler = PayloadStringHandler()
    
    init(anyArray: [Any]) {
        self.anyArray = anyArray
    }
    
    mutating func next() -> (index: Int, messageIndex: Int, text: String)? {
        while currentIndex < anyArray.count {
            if var itemDict = anyArray[currentIndex] as? [String: Any] {
                // Check for 'updated_item' key
                if var updatedItem = itemDict["updated_item"] as? [String: Any],
                   let payloadString = updatedItem["payload"] as? String {
                    
                    if let text = payloadHandler.extractText(from: payloadString) {
                        defer { currentIndex += 1 } // Move to the next item after returning the current one
                        return (index: currentIndex, messageIndex: -1, text: text)
                    }
                }
            }
            currentIndex += 1
            messageIndex = 0
        }
        return nil
    }
    
    mutating func updateCurrentText(with newText: String) {
        guard currentIndex > 0 else { return }
        let index = currentIndex - 1
        
        if index < anyArray.count {
            if var itemDict = anyArray[index] as? [String: Any] {
                // Update text in 'updated_item'
                if var updatedItem = itemDict["updated_item"] as? [String: Any],
                   let payloadString = updatedItem["payload"] as? String {
                    
                    if let newPayloadString = payloadHandler.updateText(in: payloadString, with: newText) {
                        updatedItem["payload"] = newPayloadString
                        itemDict["updated_item"] = updatedItem
                        anyArray[index] = itemDict
                    }
                }
            }
        }
    }
    
    func getUpdatedArray() -> [Any] {
        return anyArray
    }
}
