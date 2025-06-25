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
    /// - Returns: A `ListResponse<Badge>` containing the earned badges.
    /// - Throws: An `ExercismClientError` if the request fails or decoding fails.
    public func badges() async throws(ExercismClientError) -> ListResponse<Badge> {
        try await networkClient.get(from: urlBuilder.url(for: ExercismClientPath.badges,
                                                         params: [:]),
                                    headers: headers)
    }
}
