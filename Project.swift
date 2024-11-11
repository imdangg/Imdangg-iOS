import ProjectDescription

let project = Project(
    name: "imdang",
    targets: [
        .target(
            name: "imdang",
            destinations: .iOS,
            product: .app,
            bundleId: "info.imdang.imdang",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                ]
            ),
            sources: ["imdang/Sources/**"],
            resources: [
                "imdang/Resources/**",
                "imdang/Sources/App/LaunchScreen.storyboard",
            ],
            dependencies: [
                .external(name: "Kingfisher"),
                .external(name: "Alamofire"),
                .external(name: "Then"),
                .external(name: "SnapKit"),
                .external(name: "ReactorKit"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
            ]
        ),
        .target(
            name: "imdangTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.imdangTests",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["imdang/Tests/**"],
            resources: [],
            dependencies: [.target(name: "imdang")]
        ),
    ]
)
