//
//  DebugDictionaryBuilderTests.swift
//  logging
//
//  Created by Robert Nash on 17/05/2025.
//

import Foundation
import Testing

@testable import Logging

struct DebugDictionaryBuilderTests {
    
    @Test func serialisesPrimitiveValues() throws {
        let input: [String: Any] = [
            "name": "Alice",
            "age": 30,
            "isActive": true
        ]
        
        let json = DebugDictionaryBuilder.makeDescription(from: input)
        #expect(json.contains("\"name\" : \"Alice\""))
        #expect(json.contains("\"age\" : 30"))
        #expect(json.contains("\"isActive\" : true"))
    }
    
    @Test func sanitisesUnsupportedTypes() throws {
        let input: [String: Any] = [
            "date": Date(timeIntervalSince1970: 1),
            "url": URL(string: "https://example.com")!
        ]
        
        let json = DebugDictionaryBuilder.makeDescription(from: input)
        
        #expect(json.contains("\"url\" : \"https://example.com\""))
        #expect(json.contains("\"date\" : \"1970-01-01 00:00:01 +0000\""))
    }

    @Test func handlesNestedDictionaries() throws {
        let input: [String: Any] = [
            "outer": [
                "inner": [
                    "key": 42
                ]
            ]
        ]
        
        let json = DebugDictionaryBuilder.makeDescription(from: input)
        #expect(json.contains("\"key\" : 42"))
        #expect(json.contains("\"inner\""))
        #expect(json.contains("\"outer\""))
    }
    
    @Test func handlesArraysOfMixedTypes() throws {
        let input: [String: Any] = [
            "values": [
                1,
                "two",
                Date(timeIntervalSince1970: 0)
            ]
        ]
        
        let json = DebugDictionaryBuilder.makeDescription(from: input)
        #expect(json.contains("1"))
        #expect(json.contains("\"two\""))
        #expect(json.contains("1970") || json.contains("UTC") || json.contains("GMT"))
    }

    @Test func fallbackForNonJSONConvertible() throws {
        struct NotEncodable {}
        let input: [String: Any] = ["bad": NotEncodable()]
        
        let output = DebugDictionaryBuilder.makeDescription(from: input)
        #expect(output.contains("bad"))
        #expect(output.contains("NotEncodable"))
    }
    
    @Test func sanitisesString() throws {
        let result = DebugDictionaryBuilder.makeDescription(from: ["value": "Hello"])
        #expect(result.contains("\"value\" : \"Hello\""))
    }

    @Test func sanitisesInt() throws {
        let result = DebugDictionaryBuilder.makeDescription(from: ["value": 42])
        #expect(result.contains("\"value\" : 42"))
    }

    @Test func sanitisesDouble() throws {
        let result = DebugDictionaryBuilder.makeDescription(from: ["value": 3.14])
        #expect(result.contains("\"value\" : 3.14"))
    }

    @Test func sanitisesBool() throws {
        let result = DebugDictionaryBuilder.makeDescription(from: ["value": true])
        #expect(result.contains("\"value\" : true"))
    }

    @Test func sanitisesNull() throws {
        let result = DebugDictionaryBuilder.makeDescription(from: ["value": NSNull()])
        #expect(result.contains("\"value\" : null"))
    }

    @Test func sanitisesDateWithStableFormat() throws {
        let date = Date(timeIntervalSince1970: 0)
        let result = DebugDictionaryBuilder.makeDescription(from: ["value": date])
        #expect(result.contains("\"value\" : \"1970-01-01 00:00:00 +0000\""))
    }

    @Test func sanitisesNestedDictionary() throws {
        let input: [String: Any] = [
            "outer": ["inner": ["key": "value"]]
        ]
        let result = DebugDictionaryBuilder.makeDescription(from: input)
        #expect(result.contains("\"key\" : \"value\""))
    }

    @Test func sanitisesArrayOfMixedValues() throws {
        let input: [String: Any] = [
            "values": ["text", 123, Date(timeIntervalSince1970: 0)]
        ]
        let result = DebugDictionaryBuilder.makeDescription(from: input)
        #expect(result.contains("\"text\""))
        #expect(result.contains("123"))
        #expect(result.contains("1970-01-01 00:00:00 +0000"))
    }

    @Test func sanitisesUnsupportedTypeUsingStringDescribing() throws {
        struct Custom {}
        let input: [String: Any] = ["custom": Custom()]
        let result = DebugDictionaryBuilder.makeDescription(from: input)
        #expect(result.contains("Custom"))
    }
}
