# DebugDictionaryBuilder

A small Swift utility for generating readable, pretty-printed JSON debug descriptions from `[String: Any]` dictionaries — even when they contain non-JSON-safe values like `Date`, `URL`, or custom types.

## Features

- ✅ Pretty-printed JSON output
- ✅ Sanitises unsupported types (e.g. `Date`, `URL`) using `String(describing:)`
- ✅ Handles nested dictionaries and arrays
- ✅ Uses stable date formatting (`yyyy-MM-dd HH:mm:ss Z`, UTC)
- ✅ Automatically removes escaped slashes (`\/`) for cleaner output

## Usage

```swift
let data: [String: Any] = [
    "name": "Alice",
    "joined": Date(timeIntervalSince1970: 0),
    "profile": URL(string: "https://example.com")!,
    "metadata": [
        "score": 42,
        "active": true
    ]
]

let debugString = DebugDictionaryBuilder.makeDescription(from: data)
print(debugString)

{
  "name" : "Alice",
  "joined" : "1970-01-01 00:00:00 +0000",
  "profile" : "https://example.com",
  "metadata" : {
    "score" : 42,
    "active" : true
  }
}
```

## Recommended Usage

Automatically generate debug descriptions for `RawRepresentable` types (such as enums) by using the included extension:

```swift
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

```swift
enum Status: String, CustomDebugStringConvertible {
    case success
    case failure
}

print(Status.success.debugDescription)

{
  "rawValue" : "success",
  "description" : "success"
}
```
