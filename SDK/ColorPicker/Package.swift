// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "ColorPicker",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "ColorPicker",
                 targets: ["ColorPicker"]),
    ],
    dependencies: [
        .package(path: "../Colors"),
        .package(path: "../ControlledComponents")
    ],
    targets: [
        .target(name: "ColorPicker",
                dependencies: [
                    "Colors",
                    "ControlledComponents"
                ]),
        .testTarget(
            name: "ColorPickerTests",
            dependencies: ["ColorPicker"]),
    ]
)
