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
    ///   - completed: A completion handler returning a `Result` with either a `TestSubmission` on success or an `ExercismClientError` on failure.
    public func runTest(for solution: String,
                        with contents: [SolutionFileData],
                        completed: @escaping (Result<TestSubmission, ExercismClientError>) -> Void) {
        let files = SolutionTestFiles(files: contents)
        networkClient.post(to: urlBuilder.url(for: .testSubmission, urlArgs: solution),
                           body: files,
                           headers: headers(),
                           completed: completed)
    }
    
    /// Retrieves the `TestRunResponse`
    ///
    /// - Parameters:
    ///   - link: The URL link to fetch the test run status.
    ///   - completed: A completion handler returning a `Result` with either a `TestRunResponse` on success or an `ExercismClientError` on failure.
    public func getTestRun(withLink link: String,
                           completed: @escaping (Result<TestRunResponse,
                                                 ExercismClientError>) -> Void) {
        networkClient.get(from: URL(string: link)!,
                          headers: headers(),
                          completed: completed)
    }
    
    /// Cancels an ongoing test run.
    ///
    /// - Parameters:
    ///   - link: The URL link to cancel the test run.
    ///   - completed: A completion handler returning a `Result` with either a `TestSubmission` on success or an `ExercismClientError` on failure.
    public func cancelTestRun(withLink link: String,
                              completed: @escaping (Result<TestSubmission, ExercismClientError>) -> Void) {
        networkClient.get(from: URL(string: link)!,
                          headers: headers(),
                          completed: completed)
    }
    
    /// Submits a solution for review.
    ///
    /// This action is performed after successfully running and passing all tests.
    ///
    /// - Parameters:
    ///   - link: The URL used to submit the solution.
    ///   - completed: A completion handler returning a `Result` with either a `SubmitSolutionResponse` on success or an `ExercismClientError` on failure.
    public func submitSolution(withLink link: String,
        completed: @escaping (Result<SubmitSolutionResponse, ExercismClientError>) -> Void) {
            guard let url = URL(string: link) else {
                completed(.failure(.builderError(message: "Invalid URL")))
                return
            }
            
            networkClient.post(to: url,
                body: "",
                headers: headers(),
                completed: completed
            )
        }
    
    /// Marks a solution as complete, optionally publishing it and specifying an iteration.
    ///
    /// This action is performed after submitting the solution and successfully passing all tests.
    ///
    /// - Parameters:
    ///   - solution: The identifier of the solution to be completed.
    ///   - publish: A boolean indicating whether to publish the solution (default is `false`).
    ///   - iteration: An optional iteration number to complete, if applicable.
    ///   - completed: A completion handler returning a `Result` with either a `CompletedSolution` on success or an `ExercismClientError` on failure.
    public func completeSolution(for solution: String,
                                 publish: Bool = false,
                                 iteration: Int? = nil,
                                 completed: @escaping (Result<CompletedSolution, ExercismClientError>) -> Void) {
        let payload = CompleteSolutionPayload(publish: publish, iteration: iteration)
        networkClient.patch(to: urlBuilder.url(for: .completeSolution,
                                               urlArgs: solution),
                            body: payload,
                            headers: headers(),
                            completed: completed)
    }
}
