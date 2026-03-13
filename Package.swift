// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Whisper",
    platforms: [
        .macOS("26.0")
    ],
    products: [
        .library(name: "Whisper", targets: ["Whisper"]),
        .executable(name: "whisper", targets: ["whisper-cli"])
    ],
    dependencies: [
        .package(url: "https://github.com/sbooth/SFBAudioEngine.git", from: "0.12.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "Whisper",
            dependencies: [
                .product(name: "SFBAudioEngine", package: "SFBAudioEngine"),
            ]
        ),
        .executableTarget(
            name: "whisper-cli",
            dependencies: [
                "Whisper",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "WhisperTests",
            dependencies: ["Whisper"]
        ),
    ]
)
