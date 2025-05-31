// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "logging",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
        .macOS(.v11),
        .watchOS(.v7),
    ],
    products: [
        .library(
            name: "Logging",
            targets: ["Logging"]),
    ],
    dependencies: [
        .package(url: "git@github.com:pointfreeco/swift-dependencies.git", .upToNextMinor(from: "1.8.1")),
        .package(url: "git@github.com:nashysolutions/foundation-dependencies.git", .upToNextMinor(from: "3.0.0")),
    ],
    targets: [
        .target(
            name: "Logging",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "FoundationDependencies", package: "foundation-dependencies")
            ]
        ),
        .testTarget(
            name: "LoggingTests",
            dependencies: ["Logging"]
        )
    ]
)
