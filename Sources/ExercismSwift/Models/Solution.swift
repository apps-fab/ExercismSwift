//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct Solution: Sendable, Codable, Hashable {
    public let uuid: String
    public let privateUrl: String
    public let publicUrl: String
    public let status: SolutionStatus
    public let mentoringStatus: String
    public let publishedIterationHeadTestsStatus: String
    public let hasNotifications: Bool
    public let numViews: Int
    public let numStars: Int
    public let numComments: Int
    public let numIterations: Int
    public let numLoc: Int
    public let isOutOfDate: Bool
    public let publishedAt: Date?
    public let completedAt: Date?
    public let updatedAt: Date?
    public let lastIteratedAt: Date?
    public let exercise: BaseInfo
    public let track: BaseInfo
}

public enum SolutionStatus: String, Codable, Sendable {
    case started
    case iterated
    case published
    case completed
}

public enum MentoringStatus: String {
    case none
    case finished
}
