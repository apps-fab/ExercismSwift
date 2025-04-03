//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct Track: Sendable, Codable, Hashable, Identifiable {
    public let slug: String
    public let title: String
    public let course: Bool
    public let numExercises: Int
    public let numConcepts: Int
    public let webUrl: String
    public let iconUrl: String
    public let tags: [String]
    public let lastTouchedAt: Date?
    public let isNew: Bool
    public let links: ResultLink?
    let isJoined: Bool?
    let numLearntConcepts: Int?
    let numCompletedExercises: Int?
    let numSolutions: Int?
    let hasNotifications: Bool?

    public var id: String {
        slug
    }

    public var _isJoined: Bool {
        return isJoined ?? false
    }

    public var _numLearntConcepts: Int {
        return numLearntConcepts ?? 0
    }

    public var _hasNotifications: Bool {
        return hasNotifications ?? false
    }

    public var _numSolutions: Int {
        return numSolutions ?? 0
    }

    public var _numCompletedExercises: Int {
        return numCompletedExercises ?? 0
    }
}
