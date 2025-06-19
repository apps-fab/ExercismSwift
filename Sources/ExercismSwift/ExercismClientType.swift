import Foundation

public protocol ExercismClientType: AnyObject {
    func tracks() async throws -> ListResponse<Track>
    
    func exercises(for track: String) async throws -> ListResponse<Exercise>
    
    func validateToken() async throws -> ValidateTokenResponse
    
    func solutions(for track: String?,
                   withStatus status: SolutionStatus?,
                   mentoringStatus: MentoringStatus?) async throws -> ListResponse<Solution>
    
    func downloadSolution(with id: String,
                          for track: String,
                          exercise: String) async throws -> ExerciseDocument
    
    func initialSolution(for track: String) async throws -> InitialFiles
    
    func getIterations(for solutionId: String) async throws -> IterationResponse
    
    func badges() async throws -> ListResponse<Badge>
    
    func getTestRun(withLink link: String) async throws -> TestRunResponse
    
    func submitSolution(withLink link: String) async throws -> SubmitSolutionResponse
    
    func completeSolution(for solution: String,
                          publish: Bool,
                          iteration: Int?) async throws -> CompletedSolution
    
    func runTest(for solution: String,
                 with contents: [SolutionFileData]) async throws -> TestSubmission
}
