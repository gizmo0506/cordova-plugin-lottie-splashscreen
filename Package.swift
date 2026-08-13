// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "cordova-plugin-lottie-splashscreen",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "cordova-plugin-lottie-splashscreen",
            targets: ["cordova-plugin-lottie-splashscreen"]
        ),
    ],
    dependencies: [
        // Capacitor CLI rewrites apache/cordova-ios -> ionic-team/capacitor-swift-pm on cap sync.
        .package(url: "https://github.com/apache/cordova-ios.git", revision: "rel/8.1.1"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.6.1"),
    ],
    targets: [
        .target(
            name: "cordova-plugin-lottie-splashscreen",
            dependencies: [
                .product(name: "Cordova", package: "cordova-ios"),
                .product(name: "Lottie", package: "lottie-spm"),
            ],
            path: "src/ios"
        ),
    ]
)
