import Foundation

// MARK: - Tracks

extension ExercismClient {
    /// Fetches a list of available tracks.
    ///
    /// - Returns: An array of `Track` objects available to the user.
    /// - Throws: An `ExercismClientError` if the request fails or decoding fails.
    public func tracks() async throws(ExercismClientError) -> ListResponse<Track> {
        try await networkClient.get(from: urlBuilder.url(for: .tracks), headers: headers)
    }
}
