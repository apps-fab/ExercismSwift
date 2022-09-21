import Foundation

// MARK: - Tracks

extension ExercismClient {
    public func validateToken(
        completed: @escaping (Result<ValidateTokenResponse, ExercismClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(path: "/v2/validate_token"),
            headers: headers(),
            completed: completed
        )
    }
}
