import Foundation

// MARK: - Tracks

extension ExercismClient {
    public func exercises(for track: String,
        completed: @escaping (Result<ListResponse<Exercise>, ExercismClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(path: ExercismClientPath.exercises, params: [:], urlArgs: track),
            headers: headers(),
            completed: completed
        )
    }
}
