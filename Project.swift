import ProjectDescription

let project = Project(
    name: "imdangg",
    targets: [
        .target(
            name: "imdangg",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.imdangg",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["imdangg/Sources/**"],
            resources: ["imdangg/Resources/**"],
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
            name: "imdanggTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.imdanggTests",
            infoPlist: .default,
            sources: ["imdangg/Tests/**"],
            resources: [],
            dependencies: [.target(name: "imdangg")]
        ),
    ]
)
