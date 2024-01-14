// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Karte",
    platforms: [
        .iOS(.v12),
        .visionOS(.v1),
        .macCatalyst(.v14)
    ],
    products: [
        .library(
            name: "Karte",
            targets: ["Karte"]),
    ],
    targets: [
        .target(
            name: "Karte",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "KarteTests",
            dependencies: ["Karte"]),
    ]
)
