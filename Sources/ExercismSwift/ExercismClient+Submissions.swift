import Foundation

// Submission of test and solutions.
//
// Created by Kirk Agbenyegah on 04/02/2023.
//

extension ExercismClient {
    public func runTest(
        for solution: String,
        withFileContents contents: [SolutionFileData],
        completed: @escaping (Result<TestSubmission, ExercismClientError>) -> Void
    ) {
        let files = SolutionTestFiles(files: contents)
        networkClient.post(
            urlBuilder.url(path: .testSubmission, urlArgs: solution),
            body: files,
            headers: headers(),
            completed: completed
        )
    }

    public func getTestRun(
        withLink link: String,
        completed: @escaping (Result<TestRunResponse, ExercismClientError>) -> Void
    ) {
        networkClient.get(URL(string: link)!, headers: headers(), completed: completed)
    }

    public func cancelTestRun(
        withLink link: String,
        completed: @escaping (Result<TestSubmission, ExercismClientError>) -> Void
    ) {
        networkClient.get(URL(string: link)!, headers: headers(), completed: completed)
    }

    public func submitSolution(
        withLink link: String,
        completed: @escaping (Result<SubmitSolutionResponse, ExercismClientError>) -> Void
    ) {
        networkClient.post(URL(string: link)!, body: "", headers: headers(), completed: completed)
    }

    public func completeSolution(
        for solution: String,
        publish: Bool = false,
        iteration: Int? = nil,
        completed: @escaping (Result<CompletedSolution, ExercismClientError>) -> Void
    ) {
        let payload = CompleteSolutionPayload(publish: publish, iteration: iteration)
        networkClient.patch(urlBuilder.url(path: .completeSolution, urlArgs: solution), body: payload, headers: headers(), completed: completed)
    }

    struct CompleteSolutionPayload: Codable {
        let publish: Bool
        let iteration: Int?
    }
}
