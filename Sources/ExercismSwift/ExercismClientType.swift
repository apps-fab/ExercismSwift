import Foundation

public protocol ExercismClientType: AnyObject {
    func tracks(completed: @escaping (Result<ListResponse<Track>,
                                      ExercismClientError>) -> Void)
    
    func exercises(for track: String,
                   completed: @escaping (Result<ListResponse<Exercise>,
                                         ExercismClientError>) -> Void)
    
    func validateToken(completed: @escaping (Result<ValidateTokenResponse,
                                             ExercismClientError>) -> Void)
    
    func solutions(for track: String?,
                   withStatus status: SolutionStatus?,
                   mentoringStatus: MentoringStatus?,
                   completed: @escaping (Result<ListResponse<Solution>,
                                         ExercismClientError>) -> Void)
    
    func downloadSolution(with id: String,
                          for track: String,
                          exercise: String,
                          completed: @escaping (Result<ExerciseDocument,
                                                ExercismClientError>) -> Void)
    
    func initialSolution(for track: String,
                         completed: @escaping (Result<InitialFiles,
                                               ExercismClientError>) -> Void)
    func getIterations(for solutionId: String,
                       completed: @escaping (Result<IterationResponse, ExercismClientError>) -> Void)
    func badges(completed: @escaping (Result<ListResponse<Badge>,
                                      ExercismClientError>) -> Void)
    func getTestRun(withLink link: String,
                    completed: @escaping (Result<TestRunResponse,
                                          ExercismClientError>) -> Void)
    func submitSolution(withLink link: String,
                        completed: @escaping (Result<SubmitSolutionResponse, ExercismClientError>) -> Void)
    func completeSolution(for solution: String,
                          publish: Bool,
                          iteration: Int?,
                          completed: @escaping (Result<CompletedSolution, ExercismClientError>) -> Void)
    func runTest(for solution: String,
                        with contents: [SolutionFileData],
                        completed: @escaping (Result<TestSubmission, ExercismClientError>) -> Void)
}
