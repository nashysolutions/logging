// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "logging",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
    ],
    products: [
        .library(
            name: "Logging",
            targets: ["Logging"]
        ),
        .library(
            name: "ParsedJSONKit",
            targets: ["ParsedJSONKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", .upToNextMinor(from: "1.8.1")),
        .package(url: "https://github.com/nashysolutions/foundation-dependencies.git", .upToNextMinor(from: "3.1.0"))
    ],
    targets: [
        .target(
            name: "Logging",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "FoundationDependencies", package: "foundation-dependencies"),
            ]
        ),
        .target(
            name: "ParsedJSONKit",
            dependencies: ["Logging"]
        ),
        .testTarget(
            name: "LoggingTests",
            dependencies: ["Logging","ParsedJSONKit"]
        ),
        .testTarget(
            name: "ParsedJSONKitTests",
            dependencies: ["ParsedJSONKit"]
        )
    ]
)
