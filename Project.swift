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
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["imdang/Sources/**"],
            resources: ["imdang/Resources/**"],
            dependencies: [
                .external(name: "Kingfisher"),
                .external(name: "Alamofire"), // default is .staticFramework
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
