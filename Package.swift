// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "LiteSlider",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "LiteSlider",
            targets: ["LiteSlider"]
        )
    ],
    targets: [
        .target(
            name: "LiteSlider"
        ),
    ],
)
