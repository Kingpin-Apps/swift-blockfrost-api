import Testing
import Foundation
@testable import SwiftBlockfrostAPI

@Test("Example health check", .enabled(if: ProcessInfo.processInfo.environment["BLOCKFROST_API_KEY"] != nil)) func example() async throws {
    let api = Blockfrost(network: .mainnet, environmentVariable: "BLOCKFROST_API_KEY")
    
    let data = try await api.client.getHealth()
    let result = try data.ok.body.json
    #expect(try result.isHealthy)
}
