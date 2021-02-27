// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "API",
    platforms: [
        .iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13)
    ],
    products: [
        .library(name: "API", targets: ["API"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "API", dependencies: []),
        .testTarget(name: "APITests", dependencies: ["API"])
    ]
)
