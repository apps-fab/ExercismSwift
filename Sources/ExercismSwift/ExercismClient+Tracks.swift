import Foundation

// MARK: - Tracks

extension ExercismClient {
    public func tracks(
        completed: @escaping (Result<ListResponse<Track>, ExercismClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(path: "/v2/tracks"),
            headers: headers(),
            completed: completed
        )
    }
}
