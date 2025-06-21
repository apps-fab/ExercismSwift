import Foundation

// MARK: - Tracks

extension ExercismClient {
    /// Validates the user's authentication token.
    ///
    /// - Returns: A `ValidateTokenResponse` indicating whether the token is valid.
    /// - Throws: An `ExercismClientError` if the request fails or decoding fails.
    public func validateToken() async throws(ExercismClientError) -> ValidateTokenResponse {
        try await networkClient.get(from: urlBuilder.url(for: .validateToken),
                                    headers: headers())
    }
}
