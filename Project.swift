import ProjectDescription

let signingSettings = SettingsDictionary()
    .automaticCodeSigning(devTeam: "ahe64mz9kc") // Replace YOUR_TEAM_ID with your Apple Developer Team ID

let project = Project(
    name: "BertCam",
    organizationName: "BertCam",
    settings: .settings(configurations: [
        .debug(name: "Debug", settings: signingSettings),
        .release(name: "Release", settings: signingSettings)
    ]),
    targets: [
        .target(
            name: "BertCam",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "com.bertcam.app",
            infoPlist: .extendingDefault(with: [
                "NSCameraUsageDescription": "BertCam needs access to your camera to record videos",
                "NSMicrophoneUsageDescription": "BertCam needs access to your microphone to record audio",
                "NSPhotoLibraryUsageDescription": "BertCam needs access to your photo library to save recorded videos",
                "NSPhotoLibraryAddUsageDescription": "BertCam needs access to your photo library to save recorded videos",
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [
                            [
                                "UISceneConfigurationName": "Default Configuration",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                            ]
                        ]
                    ]
                ]
            ]),
            sources: ["Sources/**"],
            resources: [.glob(pattern: "Resources/**")],
            dependencies: []
        )
    ]
)
