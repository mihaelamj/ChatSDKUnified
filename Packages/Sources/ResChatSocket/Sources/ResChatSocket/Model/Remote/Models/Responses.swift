//
//  Responses.swift
//
//
//  Created by Mihaela MJ on 01.08.2024..
//

import Foundation

// MARK: ResponseOK -

public struct ResponseOK: Codable {
    let success: Bool
    let message: String?
    
    init(success: Bool = true, message: String? = nil) {
        self.success = success
        self.message = message
    }
}

extension ResponseOK: CustomDebugStringConvertible {
    public var debugDescription: String { description }
}

extension ResponseOK: CustomStringConvertible {
    public var description: String {
        "ResponseOK(success: \(success), message: \(message ?? "No message"))"
    }
}

// MARK: ResponseError -

public struct ResponseError: Codable {
    let success: Bool
    let error: String
    let message: String?
    
    init(success: Bool = false, error: String, message: String?) {
        self.success = success
        self.error = error
        self.message = message
    }
}

extension ResponseError: CustomStringConvertible {
    public var description: String {
        "ResponseError(success: \(success), error: \(error), message: \(message ?? "No message"))"
    }
}

extension ResponseError: CustomDebugStringConvertible {
    public var debugDescription: String { description }
}

// MARK: Response -

public enum Response {
    case success(ResponseOK)
    case failure(ResponseError)
    
    public static func parse(from array: [Any]) -> Response? {
        guard let dictionary = array.first as? [String: Any],
              let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        if let responseOK = try? decoder.decode(ResponseOK.self, from: data) {
            return .success(responseOK)
        } else if let responseError = try? decoder.decode(ResponseError.self, from: data) {
            return .failure(responseError)
        }
        
        return nil
    }
}

extension Response: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success(let responseOK):
            return responseOK.description
        case .failure(let responseError):
            return responseError.description
        }
    }
}

extension Response: CustomDebugStringConvertible {
    public var debugDescription: String { description }
}
