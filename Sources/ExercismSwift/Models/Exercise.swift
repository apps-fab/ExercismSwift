//
// Created by Kirk Agbenyegah on 16/09/2022.
//

import Foundation

public struct Exercise: Hashable, Sendable, Decodable {
    public let slug: String
    public let type: ExerciseType
    public let title: String
    public let iconUrl: String
    public let difficulty: ExerciseDifficulty
    public let blurb: String
    public let isExternal: Bool
    public let isUnlocked: Bool
    public let isRecommended: Bool
    public let links: ResultLink
}

public enum ExerciseType: String, Sendable, Decodable {
    case concept
    case practice
    case tutorial
}

public enum ExerciseDifficulty: String,Sendable, Decodable {
    case easy
    case medium
    case hard
}
