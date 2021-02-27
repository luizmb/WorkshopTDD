// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UI",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "UI", targets: ["UI"])
    ],
    dependencies: [
        .package(name: "API", path: "../API"),
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.2")
    ],
    targets: [
        .target(name: "UI", dependencies: ["API"]),
        .testTarget(name: "UITests", dependencies: ["UI", "SnapshotTesting"])
    ]
)
