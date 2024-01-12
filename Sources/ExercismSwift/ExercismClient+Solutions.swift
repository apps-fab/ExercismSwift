import Foundation

// MARK: - Solutions

extension ExercismClient {
    public func solutions(
        for track: String? = nil,
        withStatus status: SolutionStatus? = nil,
        mentoringStatus: MentoringStatus? = nil,
        completed: @escaping (Result<ListResponse<Solution>, ExercismClientError>) -> Void
    ) {
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

        networkClient.get(
            urlBuilder.url(path: .solutions,
                           params: params),
            headers: headers(),
            completed: completed
        )
    }

    public func downloadSolution(
        with id: String = "latest",
        for track: String,
        exercise: String,
        completed: @escaping (Result<ExerciseDocument, ExercismClientError>) -> Void
    ) {
        var params: [String: String] = [:]
        params["track_id"] = track
        params["exercise_id"] = exercise

        networkClient.get(
            urlBuilder.url(path: .solutionsFile, params: params, urlArgs: id),
            headers: headers()
        ) { (result: Result<SolutionFile, ExercismClientError>) in
            switch result {
            case .success(let solution):
                let solutionManager = SolutionManager(with: solution, client: self.networkClient)
                solutionManager.download { url, error in
                    if let url = url {
                        do {
                            let exerciseDocument = try ExerciseDocument(exerciseDirectory: url, solution: solution)
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
    
    public func getIterations(
        for solutionId: String,
        completed: @escaping (Result<IterationResponse, ExercismClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(path: .iteration, urlArgs: solutionId),
            headers: headers(),
            completed: completed
        )
    }
}
