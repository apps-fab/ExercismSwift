import Foundation

// MARK: - Tracks

extension ExercismClient {
    /// Fetches a list of available tracks.
    ///
    /// - Parameter completed: A completion handler returning a `Result` with either a `ListResponse<Track>` on success or an `ExercismClientError` on failure.
    public func tracks(completed: @escaping (Result<ListResponse<Track>,
                                             ExercismClientError>) -> Void) {
            networkClient.get(from: urlBuilder.url(for: .tracks),
                              headers: headers(),
                              completed: completed)
        }
}
