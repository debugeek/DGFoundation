// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "DGFoundation",
    products: [
        .library(name: "DGFoundation", targets: ["DGFoundation"])
    ],
    targets: [
        .target(name: "DGFoundation")
    ]
)
