import Foundation

// MARK: - Tracks

extension ExercismClient {
    /// Fetches the list of exercises available for a given track.
    ///
    /// - Parameters:
    ///   - track: The identifier of the track for which exercises are to be fetched.
    ///   - completed: A completion handler that returns a `Result` containing either a `ListResponse<Exercise>` with the exercises or an `ExercismClientError` if the request fails.
    public func exercises(for track: String,
                          completed: @escaping (Result<ListResponse<Exercise>, ExercismClientError>) -> Void) {
        networkClient.get(from: urlBuilder.url(for: .exercises,
                                               urlArgs: track),
                          headers: headers(),
                          completed: completed)
    }
}
