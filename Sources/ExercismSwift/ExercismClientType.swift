import Foundation

public protocol ExercismClientType: AnyObject {
    func tracks() async throws(ExercismClientError) -> ListResponse<Track>

    func exercises(for track: String) async throws(ExercismClientError) -> ListResponse<Exercise>

    func validateToken() async throws(ExercismClientError) -> ValidateTokenResponse

    func solutions(for track: String?,
                   withStatus status: SolutionStatus?,
                   mentoringStatus: MentoringStatus?) async throws(ExercismClientError) -> ListResponse<Solution>

    func downloadSolution(with id: String,
                          for track: String,
                          exercise: String) async throws(ExercismClientError) -> ExerciseDocument

    func initialSolution(for track: String) async throws(ExercismClientError) -> InitialFiles

    func getIterations(for solutionId: String) async throws(ExercismClientError) -> IterationResponse

    func badges() async throws(ExercismClientError) -> ListResponse<Badge>

    func getTestRun(withLink link: String) async throws(ExercismClientError) -> TestRunResponse

    func submitSolution(withLink link: String) async throws(ExercismClientError) -> SubmitSolutionResponse

    func completeSolution(for solution: String,
                          publish: Bool,
                          iteration: Int?) async throws(ExercismClientError) -> CompletedSolution

    func runTest(for solution: String,
                 with contents: [SolutionFileData]) async throws(ExercismClientError) -> TestSubmission
}
