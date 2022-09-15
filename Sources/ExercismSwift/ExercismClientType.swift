import Foundation

public protocol ExercismClientType: AnyObject {
    func tracks(
            completed: @escaping (Result<ListResponse<Track>, ExercismClientError>) -> Void
    )

    func exercises(for track: String,
                   completed: @escaping (Result<ListResponse<Exercise>, ExercismClientError>) -> Void
    )


}
