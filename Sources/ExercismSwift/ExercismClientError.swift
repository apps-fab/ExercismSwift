import Foundation

public enum ExercismClientError: Error {
    case genericError(Error)
    case apiError(code: ExercismErrorCode, type: String, message: String)
    case bodyEncodingError(Error)
    case decodingError(Error)
    case unsupportedResponseError
    case builderError(message: String)
    
    public var description: String {
        switch self {
        case .genericError(let underlyingError):
            return "An error occurred: \(underlyingError.localizedDescription)"
        case .apiError(let code, let type, let message):
            return "API Error - Code: \(code.rawValue), Type: \(type), Message: \(message)"
        case .bodyEncodingError(let underlyingError):
            return "Error encoding request body: \(underlyingError.localizedDescription)"
        case .decodingError(let underlyingError):
            return "Error decoding response: \(underlyingError.localizedDescription)"
        case .unsupportedResponseError:
            return "Received an unsupported response"
        case .builderError(let message):
            return "Builder Error: \(message)"
        }
    }
}

public enum ExercismErrorCode: String {
    case invalidJson = "invalid_json"
    case invalidRequestURL = "invalid_request_url"
    case invalidRequest = "invalid_request"
    case validationError = "validation_error"
    case unauthorized = "unauthorized"
    case invalidToken = "invalid_auth_token"
    case genericError
}
