// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "FileTree",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "FileTree",
                 targets: ["FileTree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tonyarnold/Differ.git", branch: "main"),
        .package(url: "https://github.com/njdehoog/Witness.git", branch: "master"),
    ],
    targets: [
        .target(name: "FileTree",
                dependencies: ["Differ", "Witness"]),
        .testTarget(name: "FileTreeTests",
                    dependencies: ["FileTree"]),
    ]
)
