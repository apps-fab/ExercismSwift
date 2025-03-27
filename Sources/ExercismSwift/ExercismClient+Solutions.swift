import Foundation

// MARK: - Solutions

extension ExercismClient {

    /// Fetches solutions for a given track with optional filters.
    ///
    /// - Parameters:
    ///   - track: The track name associated with the solutions (optional).
    ///   - status: The status of the solutions to fetch (optional).
    ///   - mentoringStatus: The mentoring status of the solutions (optional).
    ///   - completed: A completion handler that returns a `Result` containing either a list of solutions (`ListResponse<Solution>`) or an `ExercismClientError` if the request fails.
    public func solutions(for track: String? = nil,
                          withStatus status: SolutionStatus? = nil,
                          mentoringStatus: MentoringStatus? = nil,
                          completed: @escaping (Result<ListResponse<Solution>,
                                                ExercismClientError>) -> Void) {
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

        networkClient.get(from: urlBuilder.url(for: .solutions,
                                               params: params),
                          headers: headers(),
                          completed: completed)
    }

    /// Fetches the initial solution files for a given solution so that user can revert to the original state of the given exercise.
    ///
    /// - Parameters:
    ///   - solutionId: The unique identifier of the solution.
    ///   - completed: A completion handler that returns a `Result` containing either the initial solution files (`InitialFiles`) or an `ExercismClientError` if the request fails.
    public func initialSolution(for solutionId: String,
                                completed: @escaping (Result<InitialFiles,
                                                      ExercismClientError>) -> Void) {
        networkClient.get(from: urlBuilder.url(for: .initialFiles,
                                               urlArgs: solutionId),
                          headers: headers(),
                          completed: completed)
    }

    /// Downloads the solution file for a given exercise.
    ///
    /// - Parameters:
    ///   - id: The solution identifier. Defaults to `"latest"`, which fetches the most recent solution.
    ///   - track: The track ID to which the exercise belongs.
    ///   - exercise: The exercise ID for which the solution is being downloaded.
    ///   - completed: A completion handler that returns a `Result` containing either an `ExerciseDocument` if successful or an `ExercismClientError` if the request fails.
    public func downloadSolution(with id: String = "latest",
                                 for track: String,
                                 exercise: String,
                                 completed: @escaping (Result<ExerciseDocument,
                                                       ExercismClientError>) -> Void) {
        var params: [String: String] = [:]
        params["track_id"] = track
        params["exercise_id"] = exercise

        networkClient.get(from: urlBuilder.url(for: .solutionsFile,
                                               params: params,
                                               urlArgs: id),
                          headers: headers()) { (result: Result<SolutionFile,
                                                 ExercismClientError>) in
            switch result {
            case .success(let solution):
                let solutionManager = SolutionManager(with: solution,
                                                      client: self.networkClient)
                solutionManager.download { url, error in
                    if let url = url {
                        do {
                            let exerciseDocument = try ExerciseDocument(exerciseDirectory: url,
                                                                        solution: solution)
                            completed(.success(exerciseDocument))
                        } catch let error {
                            completed(.failure(.builderError(message: error.localizedDescription)))
                        }
                    }  else {
                        completed(.failure(.builderError(message: "Error creating exercise directory")))
                    }
                }

            case .failure(let error):
                completed(.failure(error))
            }
        }
    }

    /// Fetches the iteration history for a given solution.
    ///
    /// - Parameters:
    ///   - solutionId: The unique identifier of the solution.
    ///   - completed: A completion handler that returns a `Result` containing either an `IterationResponse` if successful or an `ExercismClientError` if the request fails.
    public func getIterations(for solutionId: String,
                              completed: @escaping (Result<IterationResponse, ExercismClientError>) -> Void) {
        networkClient.get(from: urlBuilder.url(for: .iteration,
                                               urlArgs: solutionId),
                          headers: headers(),
                          completed: completed)
    }
}
