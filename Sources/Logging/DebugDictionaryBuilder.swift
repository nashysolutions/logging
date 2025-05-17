//
//  DebugDictionaryBuilder.swift
//  logging
//
//  Created by Robert Nash on 17/05/2025.
//

import Foundation

public enum DebugDictionaryBuilder {
    
    public static func makeDescription(from dictionary: [String: Any]) -> String {
        let safeDict = sanitise(dictionary)
        if let data = try? JSONSerialization.data(withJSONObject: safeDict, options: [.prettyPrinted]),
           var json = String(data: data, encoding: .utf8) {
            json = json.replacingOccurrences(of: "\\/", with: "/")
            return json
        } else {
            return String(describing: safeDict)
        }
    }
    
    private static func sanitise(_ dictionary: [String: Any]) -> [String: Any] {
        dictionary.mapValues { sanitiseValue($0) }
    }
    
    private static func sanitiseValue(_ value: Any) -> Any {
        switch value {
        case let string as String:
            return string
        case let int as Int:
            return int
        case let double as Double:
            return double
        case let bool as Bool:
            return bool
        case let null as NSNull:
            return null
        case let dict as [String: Any]:
            return sanitise(dict)
        case let array as [Any]:
            return array.map { sanitiseValue($0) }
        default:
            return String(describing: value)
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
