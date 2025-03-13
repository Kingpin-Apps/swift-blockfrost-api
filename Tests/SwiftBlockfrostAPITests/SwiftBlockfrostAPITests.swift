import Testing
@testable import SwiftBlockfrostAPI

@Test("Example health check", .disabled()) func example() async throws {
    let api = Blockfrost(network: .mainnet, projectId: "project_id")
    
    let data = try await api.client.getHealth()
    let result = try data.ok
    print(try result.body.json.isHealthy)
}
