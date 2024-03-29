import Foundation

// MARK: - Tracks

extension ExercismClient {
    public func validateToken(
        completed: @escaping (Result<ValidateTokenResponse, ExercismClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(path: .validateToken),
            headers: headers(),
            completed: completed
        )
    }
}
