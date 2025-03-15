![GitHub Workflow Status](https://github.com/Kingpin-Apps/swift-blockfrost-api/actions/workflows/swift.yml/badge.svg)

# SwiftBlockfrostAPI - OpenAPI generated client for Blockfrost.io

SwiftBlockfrostAPI is a Swift implementation of the OpenAPI client for Blockfrost.io and is generated using [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator).

## Usage
To add SwiftBlockfrostAPI as dependency to your Xcode project, select `File` > `Swift Packages` > `Add Package Dependency`, enter its repository URL: `https://github.com/Kingpin-Apps/swift-blockfrost-api.git` and import `SwiftBlockfrostAPI`. Build project to generate the module.

Then, to use it in your source code, add:

```swift
import SwiftBlockfrostAPI

let api = Blockfrost(network: .mainnet, projectId: "project_id")

let data = try await api.client.getHealth()
let result = try data.ok
print(try result.body.json.isHealthy)
```
