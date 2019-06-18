// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "AliceDreemurr",
    dependencies: [
        .package(url: "https://github.com/ProjectAliceDev/dreemurr", from: "0.1.7"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AliceDreemurr",
            dependencies: ["Logging", "dreemurr"]),
        .testTarget(
            name: "AliceDreemurrTests",
            dependencies: ["AliceDreemurr"]),
    ]
)
