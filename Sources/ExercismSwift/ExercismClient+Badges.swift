//
//  File.swift
//  
//
//  Created by Angie Mugo on 29/09/2022.
//

import Foundation

// MARK: - Badges

extension ExercismClient {
    /// Fetches the list of badges earned by the user.
    ///
    /// - Parameter completed: A completion handler that returns a `Result` containing either a `ListResponse<Exercise>` with the earned badges or an `ExercismClientError` if the request fails.
    public func badges(completed: @escaping (Result<ListResponse<Exercise>,
                                             ExercismClientError>) -> Void) {
        networkClient.get(from: urlBuilder.url(for: ExercismClientPath.badges,
                                               params: [:]),
                          headers: headers(),
                          completed: completed)
    }
}
