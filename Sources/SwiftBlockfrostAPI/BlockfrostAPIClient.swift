import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import HTTPTypes

/// The network to use.
public enum Network {
    case mainnet
    case preprod
    case preview
    
    public func url() throws -> URL {
        switch self {
            case .mainnet:
                return try Servers.Server1.url()
            case .preprod:
                return try Servers.Server2.url()
            case .preview:
                return try Servers.Server3.url()
        }
    }
}

extension HTTPField.Name {
    public static var projectId: Self { .init("Project_id")! }
}

/// A client middleware that injects a value into the `Authorization` header field of the request.
package struct AuthenticationMiddleware {

    /// The value for the `Authorization` header field.
    private let projectId: String

    /// Creates a new middleware.
    /// - Parameter value: The value for the `Authorization` header field.
    package init(authorizationHeaderFieldValue projectId: String) { self.projectId = projectId }
}

extension AuthenticationMiddleware: ClientMiddleware {
    package func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        // Adds the `Authorization` header field with the provided value.
        request.headerFields[.projectId] = projectId
        return try await next(request, body, baseURL)
    }
}

public struct Blockfrost {
    public let client: Client
    public let network: Network
    public let projectId: String
    
    public init(
        network: Network,
        projectId: String? = nil,
        basePath: String? = nil,
        environmentVariable: String? = "BLOCKFROST_API_KEY",
        client: Client? = nil,
    ) throws {
        self.network = network
        
        if let projectId = projectId {
            self.projectId = projectId
        } else if let environmentVariable = environmentVariable {
            guard let projectId = ProcessInfo.processInfo.environment[environmentVariable],
                  !projectId.isEmpty else {
                throw BlockfrostAPIError.missingProjectId("Environment variable \(environmentVariable) is not set or empty.")
            }
            self.projectId = projectId
        } else {
            throw BlockfrostAPIError.missingProjectId("No project ID provided and no environment variable specified.")
        }
        
        let serverURL: URL
        if let basePath = basePath {
            guard let url = URL(string: basePath) else {
                throw BlockfrostAPIError.invalidBasePath("Invalid base path: \(basePath)")
            }
            serverURL = url
        } else {
            guard let url = try? network.url() else {
                throw BlockfrostAPIError.invalidBasePath("Could not determine server URL for network \(network).")
            }
            serverURL = url
        }
        
        self.client = client ?? Client(
            serverURL: serverURL,
            transport: URLSessionTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: self.projectId)]
        )
    }
            
}
