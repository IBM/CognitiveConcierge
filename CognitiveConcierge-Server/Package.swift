// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CognitiveConcierge",
    products: [
      .executable(
        name: "CognitiveConcierge",
        targets:  ["CognitiveConcierge"]
      )
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.1.0")),
        .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/IBM/metrics-tracker-client-swift.git", .upToNextMinor(from: "5.0.0")),
        .package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", .upToNextMajor(from: "17.0.0"))
	],
  targets: [
    .target(
      name: "CognitiveConcierge",
      dependencies: ["Kitura", "SwiftyJSON", "CloudEnvironment", "MetricsTrackerClient"],
      path: "."
    )
  ]
)
