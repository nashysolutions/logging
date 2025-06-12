# Logging

Tools for producing readable, structured, and safe debug output in Swift.

This package includes:

- `DebugDictionaryBuilder`: pretty-prints `[String: Any]` as JSON for debugging
- `ParsedJSONKit`: inspects JSON output and assists with test assertions

---

## Features

- ✅ Pretty-printed JSON debug output
- ✅ Sanitises unsupported types (`Date`, `URL`, etc.)
- ✅ Handles nested dictionaries and arrays
- ✅ Stable and locale-independent date formatting (`yyyy-MM-dd HH:mm:ss Z`)
- ✅ Automatically removes escaped slashes (`\/`)
- ✅ Optional redaction of sensitive fields
- ✅ JSON inspection for test validation (via `ParsedJSONKit`)

---

## SPM Integration

```swift
.package(url: "https://github.com/your-org/logging", from: "1.0.0")
```

```swift
.target(
  name: "YourTarget",
  dependencies: [
    .product(name: "Logging", package: "logging"),
    .product(name: "ParsedJSONKit", package: "logging")
  ]
)
```

## Usage

### Debug Output

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

let builder = DebugDictionaryBuilder()
let debugString = builder.makeDescription(from: data)
print(debugString)
```

Prints:

```json
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

---

### Redacting Sensitive Values

You can redact specific fields based on key name matches:

```swift
let builder = DebugDictionaryBuilder(redactKeys: ["password", "token"])
let output = builder.makeDescription(from: [
    "username": "Alice",
    "token": "abc123"
])
```

Prints:

```json
{
  "username" : "Alice",
  "token" : {
    "value" : "[REDACTED]",
    "isNilOrEmpty" : false
  }
}
```

---

## Testing & Inspection

Use `ParsedJSONKit` to inspect JSON structure in tests:

```swift
let builder = DebugDictionaryBuilder()
let json = builder.makeDescription(from: ["key": "value"])
let parsed = try JSONInspector(json)

#expect(parsed.topLevelKeyCount == 1)
#expect(try parsed.require("key", as: String.self) == "value")
```
