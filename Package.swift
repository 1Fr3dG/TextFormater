// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "TextFormater",
    products: [
        .library(
            name: "TextFormater",
            targets: ["TextFormater"]),
    ],
    targets: [
        .target(
            name: "TextFormater",
            path: "Sources"
            )
    ]
)
