//
//  DebugDictionaryBuilder.swift
//  logging
//
//  Created by Robert Nash on 17/05/2025.
//

import Foundation

/// A builder that generates pretty-printed JSON descriptions from `[String: Any]` dictionaries,
/// optionally redacting values based on specified key content.
public struct DebugDictionaryBuilder {
    
    /// A set of keys whose values should be redacted from the output.
    public var redactKeys: Set<String>

    /// Creates a new `DebugDictionaryBuilder`.
    ///
    /// - Parameter redactKeys: A set of string fragments to match against keys. If a key contains any of these values (case-insensitive), its value will be redacted.
    public init(redactKeys: Set<String> = []) {
        self.redactKeys = redactKeys
    }

    /// Generates a JSON string representation of the given dictionary.
    ///
    /// This method sanitises the dictionary to ensure unsupported types (like `Date`, `URL`, and custom structs)
    /// are safely serialised. It also redacts values for keys that match `redactKeys`.
    ///
    /// - Parameter dictionary: A `[String: Any]` dictionary to format.
    /// - Returns: A JSON-formatted string suitable for debugging.
    public func makeDescription(from dictionary: [String: Any]) -> String {
        let safeDict = sanitise(dictionary)
        if let data = try? JSONSerialization.data(withJSONObject: safeDict, options: [.prettyPrinted]),
           var json = String(data: data, encoding: .utf8) {
            json = json.replacingOccurrences(of: "\\/", with: "/")
            return json
        } else {
            return String(describing: safeDict)
        }
    }

    /// Sanitises all values in a dictionary, transforming them into JSON-safe types.
    ///
    /// - Parameter dictionary: A `[String: Any]` dictionary to sanitise.
    /// - Returns: A new dictionary with sanitised values.
    private func sanitise(_ dictionary: [String: Any]) -> [String: Any] {
        dictionary.mapValues { sanitiseValue($0) }
    }

    /// Transforms a single value into a JSON-safe representation.
    ///
    /// If the value is of an unsupported type, it is converted using `String(describing:)`.
    /// If redaction is enabled and a match is found, the output includes a placeholder, the original type, and `isNilOrEmpty` when applicable.
    ///
    /// - Parameter value: The value to transform.
    /// - Returns: A JSON-compatible value.
    private func sanitiseValue(_ value: Any) -> Any {
        switch value {
        case let string as String:
            if shouldRedact(value: string) {
                return [
                    "value": "[REDACTED]",
                    "type": "String",
                    "isNilOrEmpty": string.isEmpty
                ]
            } else {
                return string
            }
        case let int as Int:
            if shouldRedact(value: String(int)) {
                return [
                    "value": "[REDACTED]",
                    "type": "Int"
                ]
            } else {
                return int
            }
        case let double as Double:
            if shouldRedact(value: String(double)) {
                return [
                    "value": "[REDACTED]",
                    "type": "Double"
                ]
            } else {
                return double
            }
        case let bool as Bool:
            if shouldRedact(value: String(bool)) {
                return [
                    "value": "[REDACTED]",
                    "type": "Bool"
                ]
            } else {
                return bool
            }
        case _ as NSNull:
            return [
                "value": "[REDACTED]",
                "type": "Null",
                "isNilOrEmpty": true
            ]
        case let date as Date:
            return Self.dateFormatter.string(from: date)
        case let dict as [String: Any]:
            return sanitise(dict)
        case let array as [Any]:
            return array.map { sanitiseValue($0) }
        default:
            let description = String(describing: value)
            let typeName = String(describing: type(of: value))
            if shouldRedact(value: description) {
                return [
                    "value": "[REDACTED]",
                    "type": typeName
                ]
            } else {
                return description
            }
        }
    }

    /// Determines whether a given string value should be redacted.
    ///
    /// - Parameter value: The string to test.
    /// - Returns: `true` if the string matches any of the `redactKeys`; otherwise, `false`.
    private func shouldRedact(value: String) -> Bool {
        let lowercased = value.lowercased()
        return redactKeys.contains { lowercased.contains($0.lowercased()) }
    }

    /// A shared date formatter with stable output for all time zones and locales.
    ///
    /// Formats dates using `.medium` styles for both date and time.
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = .current
        formatter.timeZone = .current
        return formatter
    }()
}
