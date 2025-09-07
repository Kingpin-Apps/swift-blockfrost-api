import Testing
import OpenAPIRuntime
import Foundation
import HTTPTypes
@testable import SwiftBlockfrostAPI

struct MockTransport: ClientTransport {
    func send(_ request: HTTPTypes.HTTPRequest, body: OpenAPIRuntime.HTTPBody?, baseURL: URL, operationID: String) async throws -> (
        HTTPTypes.HTTPResponse,
        OpenAPIRuntime.HTTPBody?
    ) {
        print("MockTransport sending request for operationID: \(operationID)")
        switch operationID {
            case "get/health":
                let body = try JSONEncoder().encode(
                    Operations.GetHealth.Output.Ok.Body.JsonPayload(isHealthy: true)
                )
                return (
                    HTTPResponse(
                        status: .ok,
                        headerFields: [.contentType: "application/json"]
                    ),
                    .init(body)
                )
            case "get/health/clock":
                let body = try JSONEncoder().encode(
                    Operations.GetHealthClock.Output.Ok.Body.JsonPayload(serverTime: 100000)
                )
                return (
                    HTTPResponse(
                        status: .ok,
                        headerFields: [.contentType: "application/json"]
                    ),
                    .init(body)
                )
            case "get/epochs/latest":
                let body = try JSONEncoder().encode(
                    Components.Schemas.EpochContent(
                        epoch: 500,
                        startTime: 0,
                        endTime: Int(Date().timeIntervalSince1970)+3600,
                        firstBlockTime: 0,
                        lastBlockTime: 0,
                        blockCount: 0,
                        txCount: 0,
                        output: "output",
                        fees: "100",
                        activeStake: nil
                ))
                return (
                    HTTPResponse(
                        status: .ok,
                        headerFields: [.contentType: "application/json"]
                    ),
                    .init(body)
                )
            default:
                return (
                    HTTPResponse(status: .notFound),
                    nil
                )
        }
    }
}
