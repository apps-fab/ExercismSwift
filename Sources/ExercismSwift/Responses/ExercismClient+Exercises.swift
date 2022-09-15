import Foundation

// MARK: - Tracks

extension ExercismClient {
    public func exercises(for track: String,
        completed: @escaping (Result<ListResponse<Exercise>, ExercismClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(path: "/v2/tracks/\(track)/exercises"),
            headers: headers(),
            completed: completed
        )
    }
}
