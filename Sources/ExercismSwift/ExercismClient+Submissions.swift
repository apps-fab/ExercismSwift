// Submission of test and solutions.
//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

extension ExercismClient {
    /// Runs tests for a given solution with the provided file contents.
    ///
    /// - Parameters:
    ///   - solution: The identifier of the solution to be tested.
    ///   - contents: A list of `SolutionFileData` representing the file contents used for testing.
    /// - Returns: A `TestSubmission` result from the test run.
    /// - Throws: An `ExercismClientError` if the request or decoding fails.
    public func runTest(for solution: String,
                        with contents: [SolutionFileData]) async throws -> TestSubmission {
        let files = SolutionTestFiles(files: contents)
        return try await networkClient.post(to: urlBuilder.url(for: .testSubmission,
                                                               urlArgs: solution),
                                            body: files,
                                            headers: headers())
    }
    
    /// Retrieves the test run status.
    ///
    /// - Parameter link: The URL link to fetch the test run status.
    /// - Returns: A `TestRunResponse` representing the current status of the test run.
    /// - Throws: An `ExercismClientError` if the request or decoding fails.
    public func getTestRun(withLink link: String) async throws -> TestRunResponse {
        guard let url = URL(string: link) else {
            throw ExercismClientError.builderError(message: "Invalid URL")
        }
        return try await networkClient.get(from: url, headers: headers())
    }
    
    /// Cancels an ongoing test run.
    ///
    /// - Parameter link: The URL link to cancel the test run.
    /// - Returns: A `TestSubmission` representing the canceled test run.
    /// - Throws: An `ExercismClientError` if the request or decoding fails.
    public func cancelTestRun(withLink link: String) async throws -> TestSubmission {
        guard let url = URL(string: link) else {
            throw ExercismClientError.builderError(message: "Invalid URL")
        }
        return try await networkClient.get(from: url, headers: headers())
    }
    
    /// Submits a solution for review after successfully running and passing all tests.
    ///
    /// - Parameter link: The URL used to submit the solution.
    /// - Returns: A `SubmitSolutionResponse` indicating the result of the submission.
    /// - Throws: An `ExercismClientError` if the request or decoding fails.
    public func submitSolution(withLink link: String) async throws -> SubmitSolutionResponse {
        guard let url = URL(string: link) else {
            throw ExercismClientError.builderError(message: "Invalid URL")
        }
        return try await networkClient.post(to: url, body: "", headers: headers())
    }
    
    /// Marks a solution as complete, optionally publishing it and specifying an iteration.
    ///
    /// - Parameters:
    ///   - solution: The identifier of the solution to be completed.
    ///   - publish: A boolean indicating whether to publish the solution (default is `false`).
    ///   - iteration: An optional iteration number to complete, if applicable.
    /// - Returns: A `CompletedSolution` indicating the result of the completion action.
    /// - Throws: An `ExercismClientError` if the request or decoding fails.
    public func completeSolution(for solution: String,
                                 publish: Bool = false,
                                 iteration: Int? = nil) async throws -> CompletedSolution {
        let payload = CompleteSolutionPayload(publish: publish, iteration: iteration)
        return try await networkClient.patch(to: urlBuilder.url(for: .completeSolution,
                                                                urlArgs: solution),
                                             body: payload,
                                             headers: headers())
    }
}

