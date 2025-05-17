//
//  RawRepresentable+DebugDescription.swift
//  logging
//
//  Created by Robert Nash on 17/05/2025.
//

import Foundation

public extension RawRepresentable where Self: CustomDebugStringConvertible {

    var debugDescription: String {
        DebugDictionaryBuilder.makeDescription(from: debugDictionary)
    }
    
    var debugDictionary: [String: Any] {
        return [
            "rawValue": rawValue,
            "description": String(describing: self)
        ]
    }
}
