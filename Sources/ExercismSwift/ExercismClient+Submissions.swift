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
        with link: String,
        completed: @escaping (Result<TestSubmission, ExercismClientError>) -> Void
    ) {
        networkClient.get(URL(string: link)!, headers: headers(), completed: completed)
    }
}
