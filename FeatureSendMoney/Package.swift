// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureSendMoney",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FeatureSendMoney",
            targets: ["FeatureSendMoney"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreNetworking"),
        .package(path: "../SharedModels"),
        .package(path: "../CoreStorage")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FeatureSendMoney",
            dependencies: ["CoreNetworking", "SharedModels", "CoreStorage"]
        ),
        .testTarget(
            name: "FeatureSendMoneyTests",
            dependencies: [
                "FeatureSendMoney",
                "CoreStorage",
                "SharedModels"
            ]
        )

    ],
    swiftLanguageModes: [.v6]
)
