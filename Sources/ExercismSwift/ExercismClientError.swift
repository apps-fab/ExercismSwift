import Foundation

public enum ExercismClientError: Error {
    case genericError(String)
    case apiError(code: ExercismErrorCode, type: String, message: String)
    case bodyEncodingError(Error)
    case decodingError(Error)
    case unsupportedResponseError
    case builderError(message: String)
    case notConnectedToInternet
    case timedOut
    case cancelled
    case badURL
    case invalidRequestURL(URLError.Code)
    
    public var description: String {
        switch self {
        case .genericError(let underlyingError):
            return "An error occurred: \(underlyingError)"
        case .apiError(let code, let type, let message):
            return """
            Error Type: \(type)
            Message: \(message)
            """
        case .bodyEncodingError(let underlyingError):
            return "Error encoding request body: \(underlyingError.localizedDescription)"
        case .decodingError(let underlyingError):
            return "Error decoding response: \(underlyingError.localizedDescription)"
        case .unsupportedResponseError:
            return "Received an unsupported response"
        case .builderError(let message):
            return "Builder Error: \(message)"
        case .notConnectedToInternet:
            return "No internet connection"
        case .timedOut:
            return "The request timed out"
        case .cancelled:
            return "The request was cancelled"
        case .badURL:
            return "The request URL was invalid"
        case .invalidRequestURL(let code):
            return "Invalid request URL (URLError.Code: \(code.rawValue))"
        }
    }
}

public enum ExercismErrorCode: String {
    case invalidJson = "invalid_json"
    case invalidRequestURL = "invalid_request_url"
    case invalidRequest = "invalid_request"
    case validationError = "validation_error"
    case unauthorised = "unauthorised"
    case invalidToken = "invalid_auth_token"
    case genericError
}
