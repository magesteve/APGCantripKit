// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APGCantripKit",
    platforms: [
        .macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10)
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
