// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APGCantripKit",
    platforms: [
        .iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8)
    ],
    products: [
        .library(
            name: "APGCantripKit",
            targets: ["APGCantripKit"]),
    ],
    targets: [
        .target(
            name: "APGCantripKit"),
        .testTarget(
            name: "APGCantripKitTests",
            dependencies: ["APGCantripKit"]
        ),
    ]
)
