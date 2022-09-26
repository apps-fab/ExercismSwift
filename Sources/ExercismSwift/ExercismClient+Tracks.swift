import Foundation

// MARK: - Tracks

extension ExercismClient {
    public func tracks(
        completed: @escaping (Result<ListResponse<Track>, ExercismClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(endpoint: ExercismClientPath.tracks),
            headers: headers(),
            completed: completed
        )
    }
}
