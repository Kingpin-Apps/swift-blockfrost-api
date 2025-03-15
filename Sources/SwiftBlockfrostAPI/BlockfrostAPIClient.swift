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
        environmentVariable: String? = "BF_PROJECT_ID"
    ) {
        self.network = network
        
        if let projectId = projectId {
            self.projectId = projectId
        } else {
            self.projectId = ProcessInfo.processInfo.environment[environmentVariable!]!
        }
        
        let serverURL: URL
        if let basePath = basePath {
            serverURL = URL(string: basePath)!
        } else {
            serverURL = try! network.url()
        }
        
        self.client = Client(
            serverURL: serverURL,
            transport: URLSessionTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: self.projectId)]
        )
    }
            
}
