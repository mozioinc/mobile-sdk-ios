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
            url: "https://github.com/siteline/SwiftUI-Introspect",
            .upToNextMajor(from: "1.3.0")
        ),
        .package(
            url: "https://github.com/airbnb/lottie-ios",
            .upToNextMajor(from: "4.5.0")
        ),
        .package(
            url: "https://github.com/SDWebImage/SDWebImageSwiftUI",
            .upToNextMajor(from: "3.1.3")
        ),
        .package(
            url: "https://github.com/SDWebImage/SDWebImageSVGCoder.git",
            .upToNextMajor(from: "1.7.0")
        ),
        .package(
            url: "https://github.com/marmelroy/PhoneNumberKit",
            .upToNextMajor(from: "4.0.1")
        ),
        .package(
            url: "https://github.com/stripe/stripe-ios",
            .upToNextMajor(from: "24.1.0")
        ),
        .package(
            url: "https://github.com/hmlongco/Resolver",
            .upToNextMajor(from: "1.5.1")
        ),
        .package(
            url: "https://github.com/gonzalezreal/swift-markdown-ui",
            .upToNextMajor(from: "2.4.1")
        ),
        .package(
            url: "https://github.com/googlemaps/ios-maps-sdk",
            .upToNextMajor(from: "9.2.0")
        ),
        .package(
            url: "https://github.com/malcommac/SwiftSimplify",
            .upToNextMajor(from: "1.1.1")
        ),
        .package(
            url: "https://github.com/SwiftKickMobile/SwiftMessages",
            .upToNextMajor(from: "10.0.1")
        ),
        .package(
            url: "https://github.com/evgenyneu/keychain-swift.git",
            .upToNextMajor(from: "24.0.0")
        ),
        .package(
            url: "https://github.com/auth0/JWTDecode.swift",
            .upToNextMajor(from: "3.2.0")
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
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "JWTDecode", package: "JWTDecode.swift"),
                .target(name: "Mozio")
            ]
        ),
        .binaryTarget(
            name: "Mozio",
            url: "https://github.com/mozioinc/mobile-sdk-ios/releases/download/0.1.0/Mozio.xcframework.zip", 
            checksum: "ddecd796f27ef7c1a6a67e18ff2d543c80f7cc1aeb68a030ec55d15e42535cfa"
        )
    ]
)
