// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Logic",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(name: "Logic",
                 targets: ["Logic"]),
    ],
    dependencies: [
        .package(url: "https://github.com/davecom/SwiftGraph", branch: "master"),
        .package(url: "https://github.com/tonyarnold/Differ", branch: "main"),
        .package(path: "../Colors"),
    ],
    targets: [
        .target(
            name: "Logic",
            dependencies: [
                "SwiftGraph",
                "Differ",
                "Colors",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(name: "LogicTests",
            dependencies: ["Logic"]),
    ]
)
