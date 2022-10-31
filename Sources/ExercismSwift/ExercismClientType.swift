import Foundation

public protocol ExercismClientType: AnyObject {
    func tracks(
        completed: @escaping (Result<ListResponse<Track>, ExercismClientError>) -> Void
    )

    func exercises(for track: String,
                   completed: @escaping (Result<ListResponse<Exercise>, ExercismClientError>) -> Void
    )

    func validateToken(
        completed: @escaping (Result<ValidateTokenResponse, ExercismClientError>) -> Void
    )

    func solutions(
        for track: String?,
        withStatus status: SolutionStatus?,
        mentoringStatus: MentoringStatus?,
        completed: @escaping (Result<ListResponse<Solution>, ExercismClientError>) -> Void
    )

    func downloadSolution(
        with id: String,
        for track: String?,
        exercise: String?,
        completed: @escaping (Result<ExerciseDocument, ExercismClientError>) -> Void
    )

}
