// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PackageSwiftPcapng",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "PackageSwiftPcapng",
            targets: ["PackageSwiftPcapng"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        // .package(
        //   name: "PcapngTestData", 
        //   url: "https://github.com/hadrielk/pcapng-test-generator.git", 
        //   .revision("9a5c4163ba9bd78dba3ceedb8b3eff37495b9a4b") // Last commit on 2015-08-31
        // )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PackageSwiftPcapng",
            dependencies: [
              .product(name: "Logging", package: "swift-log"),
            ]),
        .testTarget(
            name: "PackageSwiftPcapngTests",
            dependencies: ["PackageSwiftPcapng"]),
    ]
)
