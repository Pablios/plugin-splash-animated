// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PluginSplashAnimated",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "PluginSplashAnimated",
            targets: ["SplashAnimatedPluginPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "SplashAnimatedPluginPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/SplashAnimatedPluginPlugin"),
        .testTarget(
            name: "SplashAnimatedPluginPluginTests",
            dependencies: ["SplashAnimatedPluginPlugin"],
            path: "ios/Tests/SplashAnimatedPluginPluginTests")
    ]
)