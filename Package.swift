// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "CameraModule",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CameraModule",
            targets: ["CameraModule"]
        ),
    ],
    targets: [
        .target(
            name: "CameraModule",
            dependencies: []
        ),
        .testTarget(
            name: "CameraModuleTests",
            dependencies: ["CameraModule"]
        ),
    ]
)
