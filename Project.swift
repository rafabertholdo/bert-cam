import ProjectDescription

let project = Project(
    name: "BertCam",
    organizationName: "Rafael Bertholdo",
    targets: [
        .target(
            name: "BertCam",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "com.rafaelbertholdo.bertcam",
            infoPlist: .extendingDefault(with: [
                "NSCameraUsageDescription": "BertCam needs access to your camera to record videos",
                "NSMicrophoneUsageDescription": "BertCam needs access to your microphone to record audio",
                "NSPhotoLibraryUsageDescription": "BertCam needs access to your photo library to save recorded videos",
                "NSPhotoLibraryAddUsageDescription": "BertCam needs access to your photo library to save recorded videos"
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "AHE64MZ9KC",
                    "CODE_SIGN_STYLE": "Automatic",
                    "CODE_SIGN_IDENTITY": "Apple Development"
                ]
            )
        )
    ]
)
