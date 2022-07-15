import Foundation

public protocol ExercismClientType: AnyObject {
    func tracks(
            completed: @escaping (Result<ListResponse<Track>, ExercismClientError>) -> Void
    )
}
