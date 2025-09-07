import Testing
import OpenAPIRuntime
import Foundation
import HTTPTypes
@testable import SwiftBlockfrostAPI

@Suite("Blockfrost API Tests")
struct BlockfrostAPITests {
    let api = try! Blockfrost(
        network: .mainnet,
        projectId: "fake-project-id",
        client: Client(
            serverURL: URL(string: "https://cardano-mainnet.blockfrost.io/api/v0")!,
            transport: MockTransport()
        )
    )
    
    @Test("Test get health")
    func testGetHealth() async throws {
        let data = try await api.client.getHealth()
        let result = try data.ok.body.json
        #expect(result.isHealthy)
    }
    
    @Test("Test get health clock")
    func testGetHealthClock() async throws {
        let data = try await api.client.getHealthClock()
        let result = try data.ok.body.json
        #expect(result.serverTime > 0)
    }
    
    @Test("Test get epochs latest")
    func testGetEpochsLatest() async throws {
        let data = try await api.client.getEpochsLatest()
        let result = try data.ok.body.json
        #expect(result.epoch == 500)
    }
}
