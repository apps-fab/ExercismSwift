import Foundation

// MARK: - Tracks

extension ExercismClient {
    public func validateToken(
        completed: @escaping (Result<ValidateTokenResponse, ExercismClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(path: ExercismClientPath.validateToken),
            headers: headers(),
            completed: completed
        )
    }
}
