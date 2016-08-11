import PackageDescription

let swiftyJsonUrl = "https://github.com/IBM-Swift/SwiftyJSON.git"

let package = Package(
  name: "Mustache",
  dependencies: [
    .Package(url: "https://github.com/rymcol/Bridging.git", majorVersion: 0, minor: 10),
    //TODO make this test dependency once issue https://bugs.swift.org/browse/SR-883 is resolved
    .Package(url: swiftyJsonUrl, majorVersion: 11, minor: 0)
  ],
  exclude: ["Tests/Carthage"]
)
