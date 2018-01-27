import PackageDescription

let package = Package(
    name: "CognitiveConcierge",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 2, minor: 1),
        .Package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", majorVersion: 7),
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", majorVersion:4),
        .Package(url: "https://github.com/IBM/metrics-tracker-client-swift.git", majorVersion: 5)
        ]
)
