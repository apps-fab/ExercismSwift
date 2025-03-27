import Foundation

/// A helper utility for handling network errors in the Exercism API client.
public enum NetworkClientHelpers {

    /// Determines and extracts an `ExercismClientError` from the given network response.
    ///
    /// - If a network-related error is provided, it wraps it as a `genericError`.
    /// - Otherwise, it delegates error extraction to `extractError(data:response:)`,
    ///   which inspects the response status code and decodes error messages if available.
    ///
    /// - Parameters:
    ///   - data: The response data from the network request, if available.
    ///   - response: The URL response received from the server.
    ///   - error: Any network-related error encountered.
    /// - Returns: An `ExercismClientError` if an error is detected, otherwise `nil`.
    public static func extractError(data: Data?,
                                    response: URLResponse?,
                                    error: Error?) -> ExercismClientError? {
        if let error = error {
            return .genericError(error)
        }

        return extractError(data: data, response: response)
    }

    /// Parses the HTTP response and extracts an `ExercismClientError` if an error is detected.
    /// - If the response status code is between 400 and 502, it attempts to decode the error response and extract an error message.
    /// - If decoding fails, it returns a generic HTTP error with the response status code.
    /// - If no response is available, it returns an `unsupportedResponseError`.
    ///
    /// - Parameters:
    ///   - data: The response data from the network request, if available.
    ///   - response: The URL response received from the server.
    /// - Returns: An `ExercismClientError` if an error is detected, otherwise `nil`.
    private static func extractError(data: Data?,
                                     response: URLResponse?) -> ExercismClientError? {
        guard let response = response as? HTTPURLResponse else {
            return .unsupportedResponseError
        }

        if (400..<503).contains(response.statusCode) {
            if let data = data {
                if let err = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    return .apiError(code: ExercismErrorCode(rawValue: err.error.type) ?? .genericError,
                                     type: err.error.type,
                                     message: err.error.message)
                } else {
                    return .genericError(Network.Errors.HTTPError(code: response.statusCode))
                }
            } else {
                return .genericError(Network.Errors.HTTPError(code: response.statusCode))
            }
        }

        return nil
    }

    /// Analyzes the HTTP response and error to determine if an `ExercismClientError` should be returned.
    /// - If a network-related error is provided, it wraps it as a `genericError`.
    /// - If the response is missing or invalid, it returns an `unsupportedResponseError`.
    /// - If the response status code is between 400 and 502, it returns a `genericError` with the corresponding HTTP status code.
    ///
    /// - Parameters:
    ///   - response: The URL response received from the server.
    ///   - error: Any network-related error encountered.
    /// - Returns: An `ExercismClientError` if an error is detected, otherwise `nil`.
    public static func extractError(response: URLResponse?,
                                    error: Error?) -> ExercismClientError? {
        if let error = error {
            return .genericError(error)
        }

        guard let response = response as? HTTPURLResponse else {
            return .unsupportedResponseError
        }

        if (400..<503).contains(response.statusCode) {
            return .genericError(Network.Errors.HTTPError(code: response.statusCode))
        }

        return nil
    }
}
