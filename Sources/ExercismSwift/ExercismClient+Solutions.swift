import Foundation

// MARK: - Solutions

extension ExercismClient {
    
    /// Fetches solutions for a given track with optional filters.
    ///
    /// - Parameters:
    ///   - track: The track slug associated with the solutions (optional).
    ///   - status: The solution status filter (optional).
    ///   - mentoringStatus: The mentoring status filter (optional).
    /// - Returns: A list of solutions matching the given filters.
    /// - Throws: `ExercismClientError` if the request fails.
    public func solutions(for track: String? = nil,
                          withStatus status: SolutionStatus? = nil,
                          mentoringStatus: MentoringStatus? = nil) async throws(ExercismClientError) -> ListResponse<Solution> {
        var params: [String: String] = [:]
        if let t = track {
            params["track_slug"] = t
        }
        
        if let s = status {
            params["status"] = s.rawValue
        }
        
        if let mt = mentoringStatus {
            params["mentoring_status"] = mt.rawValue
        }
        
        return try await networkClient.get(from: urlBuilder.url(for: .solutions,
                                                                params: params),
                                           headers: headers())
    }
    
    /// Fetches the initial solution files for a given solution ID to allow reverting the exercise to its original state.
    ///
    /// - Parameter solutionId: The unique identifier of the solution.
    /// - Returns: The initial files associated with the solution.
    /// - Throws: `ExercismClientError` if the request fails.
    public func initialSolution(for solutionId: String) async throws(ExercismClientError) -> InitialFiles {
        try await networkClient.get(from: urlBuilder.url(for: .initialFiles,
                                                         urlArgs: solutionId),
                                    headers: headers())
    }
    
    /// Downloads the solution files for a given exercise and returns an `ExerciseDocument`.
    ///
    /// - Parameters:
    ///   - id: The solution identifier. Defaults to `"latest"` to fetch the most recent solution.
    ///   - track: The track ID to which the exercise belongs.
    ///   - exercise: The exercise ID for which the solution is being downloaded.
    /// - Returns: An `ExerciseDocument` constructed from the downloaded files.
    /// - Throws: `ExercismClientError` if the download or document creation fails.
    public func downloadSolution(with id: String = "latest",
                                 for track: String,
                                 exercise: String) async throws(ExercismClientError) -> ExerciseDocument {
        let params: [String: String] = [
            "track_id": track,
            "exercise_id": exercise
        ]
        
        let solutionResponse: SolutionResponse = try await networkClient.get(from:
                                                                                urlBuilder.url(for: .solutionsFile,
                                                                                               params: params,
                                                                                               urlArgs: id),
                                                                             headers: headers())
        let solutionManager = SolutionManager(with: solutionResponse.solution, client: self.networkClient)
        
        let directoryURL: URL = try await solutionManager.download()
        
        do {
            return try ExerciseDocument(with: directoryURL, solution: solutionResponse.solution)
        } catch {
            throw ExercismClientError.builderError(message: error.localizedDescription)
        }
    }
    
    
    /// Fetches the iteration history for a given solution.
    ///
    /// - Parameter solutionId: The unique identifier of the solution.
    /// - Returns: An `IterationResponse` containing the iteration details.
    /// - Throws: `ExercismClientError` if the request fails.
    public func getIterations(for solutionId: String) async throws(ExercismClientError) -> IterationResponse {
        try await networkClient.get(from: urlBuilder.url(for: .iteration,
                                                         urlArgs: solutionId),
                                    headers: headers())
    }
}
