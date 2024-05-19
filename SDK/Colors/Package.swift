// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Colors",
    platforms: [.macOS(.v14)],
    products: [
        .library(
            name: "Colors",
            targets: ["Colors"]),
    ],
    targets: [
        .target(
            name: "Colors"),
        .testTarget(
            name: "ColorsTests",
            dependencies: ["Colors"]),
    ]
)
