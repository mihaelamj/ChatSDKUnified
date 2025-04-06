//
//  StreamMessageTextFieldIterator.swift
//  
//
//  Created by Mihaela MJ on 01.09.2024..
//

import Foundation

struct StreamMessageTextFieldIterator: IteratorProtocol {
    private var anyArray: [Any]
    private var currentElementIndex = 0
    private var currentTextIndex = 0
    
    init(anyArray: [Any]) {
        self.anyArray = anyArray
    }
    
    mutating func next() -> (index: Int, text: String)? {
        print("Element: \(currentElementIndex)")
        while currentElementIndex < anyArray.count {
            if let messageDict = anyArray[currentElementIndex] as? [String: Any],
               let innerMessageDict = messageDict["message"] as? [String: Any],
               let innerInnerMessageDict = innerMessageDict["message"] as? [String: Any],
               let elements = innerInnerMessageDict["elements"] as? [[String: Any]] {
                
                while currentTextIndex < elements.count {
                    if elements[currentTextIndex]["element"] as? String == "text" {
                        let text = elements[currentTextIndex]["text"] as? String ?? ""
                        let result = (index: currentElementIndex, text: text)
                        currentTextIndex += 1
                        return result
                    }
                    currentTextIndex += 1
                }
            }
            currentElementIndex += 1
            currentTextIndex = 0
        }
        return nil
    }
    
    mutating func updateCurrentText(with newText: String) {
        if currentElementIndex < anyArray.count,
           var messageDict = anyArray[currentElementIndex] as? [String: Any],
           var innerMessageDict = messageDict["message"] as? [String: Any],
           var innerInnerMessageDict = innerMessageDict["message"] as? [String: Any],
           var elements = innerInnerMessageDict["elements"] as? [[String: Any]] {
            
            if currentTextIndex > 0, currentTextIndex <= elements.count {
                elements[currentTextIndex - 1]["text"] = newText
                innerInnerMessageDict["elements"] = elements
                innerMessageDict["message"] = innerInnerMessageDict
                messageDict["message"] = innerMessageDict
                anyArray[currentElementIndex] = messageDict
            }
        }
    }
    
    func getUpdatedArray() -> [Any] {
        return anyArray
    }
}


