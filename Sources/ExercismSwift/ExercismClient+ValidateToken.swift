import Foundation

// MARK: - Tracks

extension ExercismClient {
    /// Validates the user's authentication token.
    ///
    /// - Parameter completed: A completion handler returning a `Result` with either a `ValidateTokenResponse` on success or an `ExercismClientError` on failure.
    public func validateToken(
        completed: @escaping (Result<ValidateTokenResponse, ExercismClientError>) -> Void) {
            networkClient.get(from: urlBuilder.url(for: .validateToken),
                              headers: headers(),
                              completed: completed)
        }
}
