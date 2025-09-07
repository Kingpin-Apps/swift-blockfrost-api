import Foundation

enum BlockfrostAPIError: Error, CustomStringConvertible, Equatable {
    case invalidBasePath(String?)
    case missingProjectId(String?)
    case valueError(String?)
    
    var description: String {
        switch self {
            case .invalidBasePath(let message):
                return message ?? "Invalid base path."
            case .missingProjectId(let message):
                return message ?? "The project ID is missing."
            case .valueError(let message):
                return message ?? "The value is invalid."
        }
    }
}
