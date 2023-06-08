// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCoreAudio",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SwiftCoreAudio",
            targets: ["SwiftCoreAudio"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftCoreAudioC",
            dependencies: []),
        .target(
            name: "SwiftCoreAudio",
            dependencies: ["SwiftCoreAudioC"]),
        .testTarget(
            name: "SwiftCoreAudioTests",
            dependencies: ["SwiftCoreAudio"]),
    ],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx14
)
