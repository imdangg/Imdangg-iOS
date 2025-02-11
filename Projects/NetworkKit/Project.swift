import ProjectDescription

let NetworkKit = Project(
    name: "NetworkKit",
    targets: [
        .target(
            name: "NetworkKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "info.imdang.NetworkKit",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "imdangAPI": "$(_IMDANG_API_)"
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ]
        ),
        .target(
            name: "NetworkKitTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "info.imdang.NetworkKitTests",
            infoPlist: .default,
            sources: ["NetworkKitTests/**"],
            resources: [],
            dependencies: [
                .target(name: "NetworkKit")
            ]
        ),
    ]
)
