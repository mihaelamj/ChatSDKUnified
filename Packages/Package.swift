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
        
        let chatTarget = Target.target(
            name: "ChatSDK",
            dependencies: []
        )
        
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
            dependencies: []
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
                "ResChatAppKitUI",
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
                "ResChatUIKit",
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

        var targets: [Target] = [
            appearanceTarget,
            protocolsTarget,
            loggingTarget,
            speechTarget,
            utilTarget,
            socketTarget,
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
