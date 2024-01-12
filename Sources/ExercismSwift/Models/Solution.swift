//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct Solution {
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
    public let numTterations: Int
    public let numLoc: Int
    public let isOutOfDate: Bool
    public let publishedAt: Date?
    public let completedAt: Date?
    public let updatedAt: Date?
    public let lastIteratedAt: Date?
    public let exercise: BaseInfo
    public let track: BaseInfo


    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String.self, forKey: .uuid)
        privateUrl = try container.decode(String.self, forKey: .privateUrl)
        publicUrl = try container.decode(String.self, forKey: .publicUrl)
        status = try container.decode(SolutionStatus.self, forKey: .status)
        mentoringStatus = try container.decode(String.self, forKey: .mentoringStatus)
        publishedIterationHeadTestsStatus = try container.decode(String.self, forKey: .publishedIterationHeadTestsStatus)
        hasNotifications = try container.decode(Bool.self, forKey: .hasNotifications)
        numViews = try container.decode(Int.self, forKey: .numViews)
        numStars = try container.decode(Int.self, forKey: .numStars)
        numComments = try container.decode(Int.self, forKey: .numComments)
        numTterations = try container.decode(Int.self, forKey: .numTterations)
        numLoc = try container.decode(Int?.self, forKey: .numLoc) ?? 0
        isOutOfDate = try container.decode(Bool.self, forKey: .isOutOfDate)
        publishedAt = try? container.decode(Date.self, forKey: .publishedAt)
        completedAt = try? container.decode(Date.self, forKey: .completedAt)
        updatedAt = try? container.decode(Date.self, forKey: .updatedAt)
        lastIteratedAt = try? container.decode(Date.self, forKey: .lastIteratedAt)
        exercise = try container.decode(BaseInfo.self, forKey: .exercise)
        track = try container.decode(BaseInfo.self, forKey: .track)
    }
}

extension Solution: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case uuid
        case privateUrl = "private_url"
        case publicUrl = "public_url"
        case status
        case mentoringStatus = "mentoring_status"
        case publishedIterationHeadTestsStatus = "published_iteration_head_tests_status"
        case hasNotifications = "has_notifications"
        case numViews = "num_views"
        case numStars = "num_stars"
        case numComments = "num_comments"
        case numTterations = "num_iterations"
        case numLoc = "num_loc"
        case isOutOfDate = "is_out_of_date"
        case publishedAt = "published_at"
        case completedAt = "completed_at"
        case updatedAt = "updated_at"
        case lastIteratedAt = "last_iterated_at"
        case exercise
        case track
    }
}

public enum SolutionStatus: String, Codable {
    case started
    case iterated
    case published
    case completed
}

public enum MentoringStatus: String {
    case none
    case finished
}
