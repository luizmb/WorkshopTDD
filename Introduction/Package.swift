// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Introduction",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Introduction", targets: ["Introduction"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Introduction", dependencies: []),
        .testTarget(name: "IntroductionTests", dependencies: ["Introduction"])
    ]
)
