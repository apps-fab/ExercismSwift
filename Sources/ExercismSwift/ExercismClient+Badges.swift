//
//  File.swift
//  
//
//  Created by Angie Mugo on 29/09/2022.
//

import Foundation

// MARK: - Badges

extension ExercismClient {
    public func badges(completed: @escaping (Result<ListResponse<Exercise>, ExercismClientError>) -> Void
    ) {
        networkClient.get(
            urlBuilder.url(path: ExercismClientPath.badges, params: [:]),
            headers: headers(),
            completed: completed
        )
    }
}


