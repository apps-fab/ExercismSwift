import Foundation

// MARK: - Tracks

extension ExercismClient {
    /// Fetches the list of exercises available for a given track.
    ///
    /// - Parameter track: The identifier of the track for which exercises are to be fetched.
    /// - Returns: A `ListResponse<Exercise>` containing the exercises.
    /// - Throws: An `ExercismClientError` if the request fails or decoding fails.
    public func exercises(for track: String) async throws(ExercismClientError) -> ListResponse<Exercise> {
        try await networkClient.get(from: urlBuilder.url(for: .exercises, urlArgs: track),
                                    headers: headers)
    }
}
