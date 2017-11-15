import PackageDescription

let package = Package(
    name: "restaurant-recommendations",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 6),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 6),
        .Package(url: "https://github.com/IBM-Swift/CloudConfiguration.git", majorVersion: 2),
        .Package(url: "https://github.com/IBM-Bluemix/cf-deployment-tracker-client-swift.git", majorVersion: 3, minor: 0)
        .Package(url: "https://github.com/IBM/metrics-tracker-client-swift.git", majorVersion: 5),
        ]
)
