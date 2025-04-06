// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Main",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .singleTargetLibrary("ChatSDK"),
    ],
    dependencies: [
        .package(url: "https://github.com/iwasrobbed/Down.git", from: "0.9.4"),
        .package(url: "https://github.com/socketio/socket.io-client-swift.git", from: "16.0.1")
    ],
    targets: {
        
        let appearanceTarget = Target.target(
            name: "ResChatAppearance",
            dependencies: []
        )
        
        let protocolsTarget  = Target.target(
            name: "ResChatProtocols",
            dependencies: []
        )
    
        let loggingTarget = Target.target(
            name: "ResChatLogging",
            dependencies: [
                "ResChatUtil"
            ]
        )
        
        let speechTarget = Target.target(
            name: "ResChatSpeech",
            dependencies: []
        )
        
        let utilTarget = Target.target(
            name: "ResChatUtil",
            dependencies: []
        )
        
        let socketTarget = Target.target(
            name: "ResChatSocket",
            dependencies: [
                .product(name: "SocketIO", package: "socket.io-client-swift")
            ]
        )
        
        let socketTestTarget = Target.testTarget(
            name: "ResChatSocketTests",
            dependencies: ["ResChatSocket"],
            resources: [
                .process("DemoData")
            ]
        )
        
        let attributedTextTarget  = Target.target(
            name: "ResChatAttributedText",
            dependencies: [
                "Down",
                "ResChatProtocols"
            ]
        )
        
        let commonHouTarget = Target.target(
            name: "ResChatHouCommon",
            dependencies: [
                "ResChatAppearance",
                "ResChatProtocols",
                "ResChatSocket"
            ]
        )
        
        let commonUITarget  = Target.target(
            name: "ResChatUICommon",
            dependencies: [
                "ResChatAppearance",
                "ResChatProtocols",
                "ResChatAttributedText"
            ]
        )
        
        let proxyTarget  = Target.target(
            name: "ResChatProxy",
            dependencies: [
                "ResChatSocket",
                "ResChatProtocols"
            ]
        )
        
        let messageManagerTarget  = Target.target(
            name: "ResChatMessageManager",
            dependencies: [
                "ResChatUICommon",
                "ResChatLogging"
            ]
        )
        
        
        let houUIKitTarget = Target.target(
            name: "ResChatHouUIKit",
            dependencies: [
                "ResChatUIKit",
                "ResChatSocket",
                "ResChatAppearance",
                "ResChatHouCommon",
                "ResChatSpeech"
            ]
        )
        
        let uiKitUITarget = Target.target(
            name: "ResChatUIKit",
            dependencies: [
                "ResChatAppearance",
                "ResChatMessageManager",
                "ResChatProtocols",
                "ResChatAttributedText",
                "ResChatUICommon",
                "ResChatSpeech",
                "ResChatLogging"
            ]
        )
        
        let houAppKitTarget = Target.target(
            name: "ResChatHouAppKit",
            dependencies: [
                "ResChatAppKitUI",
                "ResChatSocket",
                "ResChatAppearance",
                "ResChatHouCommon",
                "ResChatSpeech"
            ]
        )
        
        let appKitUITarget = Target.target(
            name: "ResChatAppKitUI",
            dependencies: [
                "ResChatAppearance",
                "ResChatMessageManager",
                "ResChatProtocols",
                "ResChatAttributedText",
                "ResChatUICommon",
                "ResChatSpeech",
                "ResChatLogging"
            ]
        )
        
        let chatTarget = Target.target(
            name: "ChatSDK",
            dependencies: [
                "ResChatAppearance",
                "ResChatMessageManager",
                "ResChatAttributedText",
                "ResChatHouCommon",
                "ResChatSpeech",
                "ResChatProtocols",
                "ResChatSocket",
                "ResChatProxy",
                .target(name: "ResChatHouUIKit", condition: .when(platforms: [.iOS])),
                .target(name: "ResChatUIKit", condition: .when(platforms: [.iOS])),
                .target(name: "ResChatHouAppKit", condition: .when(platforms: [.macOS])),
                .target(name: "ResChatAppKitUI", condition: .when(platforms: [.macOS]))
            ]
        )
        
        var targets: [Target] = [
            appearanceTarget,
            protocolsTarget,
            loggingTarget,
            speechTarget,
            utilTarget,
            socketTarget,
            socketTestTarget,
            attributedTextTarget,
            commonHouTarget,
            commonUITarget,
            proxyTarget,
            messageManagerTarget,
            houUIKitTarget,
            uiKitUITarget,
            houAppKitTarget,
            appKitUITarget,
            chatTarget
        ]

        return targets
    }()
)

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
