import Foundation

/// A helper utility for handling network errors in the Exercism API client.
enum NetworkClientHelpers {
    
    /// Parses the HTTP response and extracts an `ExercismClientError` if an error is detected.
    /// - If the response status code is between 400 and 502, it attempts to decode the error response and extract an error message.
    /// - If decoding fails, it returns a generic HTTP error with the response status code.
    /// - If no response is available, it returns an `unsupportedResponseError`.
    ///
    /// - Parameters:
    ///   - data: The response data from the network request, if available.
    ///   - response: The URL response received from the server.
    /// - Returns: An `ExercismClientError` if an error is detected, otherwise `nil`.
    static func extractError(data: Data?,
                             response: URLResponse?) -> ExercismClientError {
        guard let response = response as? HTTPURLResponse else {
            return .unsupportedResponseError
        }
        
        if (400..<503).contains(response.statusCode) {
            if let data = data, let err = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                return .apiError(code: ExercismErrorCode(rawValue: err.error.type) ?? .genericError,
                                 type: err.error.type,
                                 message: err.error.message)
            }
        }
        return .unsupportedResponseError
    }
    
    /// Maps a generic `Error` to a specific `ExercismClientError` with detailed handling for known error types.
    ///
    /// This function inspects the type of the error and maps it as follows:
    /// - If the error is a `DecodingError`, returns `.decodingError`.
    /// - If the error is an `EncodingError`, returns `.bodyEncodingError`.
    /// - If the error is a `URLError`, inspects the code and returns:
    ///     - `.notConnectedToInternet` for `.notConnectedToInternet`
    ///     - `.timedOut` for `.timedOut`
    ///     - `.cancelled` for `.cancelled`
    ///     - `.badURL` for `.badURL`
    ///     - `.invalidRequestURL(code)` for all other `URLError` codes
    /// - All other errors are returned as `.genericError`.
    ///
    /// - Parameter error: The error encountered during the network operation.
    /// - Returns: A corresponding `ExercismClientError`.
    static func extractError(error: Error) -> ExercismClientError {
        switch error {
        case let decodingError as DecodingError:
            return .decodingError(decodingError)
            
        case let encodingError as EncodingError:
            return .bodyEncodingError(encodingError)
            
        case let urlError as URLError:
            switch urlError.code {
            case .notConnectedToInternet:
                return .notConnectedToInternet
            case .timedOut:
                return .timedOut
            case .cancelled:
                return .cancelled
            case .badURL:
                return .badURL
            default:
                return .invalidRequestURL(urlError.code)
            }
            
        default:
            return .genericError("\(error.localizedDescription)")
        }
    }
}
