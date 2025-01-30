// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mozio",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Mozio",
            targets: ["MozioiOS"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "1.3.0")
        ),
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "4.5.0")
        ),
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "3.1.3")
        ),
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "1.7.0")
        ),
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "4.0.1")
        ),
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "24.1.0")
        ),
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "1.5.1")
        ),
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "2.4.1")
        ),
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "9.2.0")
        ),
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "1.1.1")
        ),
        .package(
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip",
            .upToNextMajor(from: "10.0.1")
        )
    ],
    targets: [
        .target(
            name: "MozioiOS",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
                .product(name: "SDWebImageSVGCoder", package: "SDWebImageSVGCoder"),
                .product(name: "Stripe", package: "stripe-ios"),
                .product(name: "StripePaymentsUI", package: "stripe-ios"),
                .product(name: "StripeApplePay", package: "stripe-ios"),
                .product(name: "StripePaymentSheet", package: "stripe-ios"),
                .product(name: "StripeCardScan", package: "stripe-ios"),
                .product(name: "Resolver", package: "Resolver"),
                .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                .product(name: "GoogleMaps", package: "ios-maps-sdk"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
                .product(name: "SwiftSimplify", package: "SwiftSimplify"),
                .product(name: "SwiftMessages", package: "SwiftMessages"),
                .product(name: "Lottie", package: "lottie-ios"),
                .target(name: "Mozio")
            ]
        ),
        .binaryTarget(
            name: "Mozio",
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip", 
            checksum: ""
        )
    ]
)
