// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureLogin",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FeatureLogin",
            targets: ["FeatureLogin"]
        ),
    ],
    
    dependencies: [
        .package(path: "../CoreNetworking"),
        .package(path: "../SharedModels")
    ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FeatureLogin",
            dependencies: ["CoreNetworking", "SharedModels"]
        ),

    ],
    
    swiftLanguageModes: [.v6]
       
    
)
