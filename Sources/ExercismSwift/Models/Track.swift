//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct Track {
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
    public let links: ResultLink
    public let isJoined: Bool
    public let numLearntConcepts: Int
    public let numCompletedExercises: Int
    public let numSolutions: Int
    public let hasNotifications: Bool


    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        slug = try container.decode(String.self, forKey: .slug)
        title = try container.decode(String.self, forKey: .title)
        course = try container.decode(Bool.self, forKey: .course)
        numExercises = try container.decode(Int.self, forKey: .numConcepts)
        numConcepts = try container.decode(Int.self, forKey: .numExercises)
        webUrl = try container.decode(String.self, forKey: .webUrl)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        tags = try container.decode(Array.self, forKey: .tags)
        lastTouchedAt = try? container.decode(Date.self, forKey: .lastTouchedAt)
        isNew = try container.decode(Bool.self, forKey: .isNew)
        links = try container.decode(ResultLink.self, forKey: .links)
        isJoined = try container.decodeIfPresent(Bool.self, forKey: .isJoined) ?? false
        numLearntConcepts = try container.decodeIfPresent(Int.self, forKey: .numLearntConcepts) ?? 0
        numCompletedExercises = try container.decodeIfPresent(Int.self, forKey: .numCompletedExercises) ?? 0
        numSolutions = try container.decodeIfPresent(Int.self, forKey: .numSolutions) ?? 0
        hasNotifications = try container.decodeIfPresent(Bool.self, forKey: .hasNotifications) ?? false
    }
}

extension Track: Decodable, Hashable, Identifiable {
    public var id: String {
        slug
    }

    enum CodingKeys: String, CodingKey {
        case slug
        case title
        case course
        case numExercises = "num_exercises"
        case numConcepts = "num_concepts"
        case webUrl = "web_url"
        case iconUrl = "icon_url"
        case tags
        case lastTouchedAt = "last_touched_at"
        case isNew = "is_new"
        case links
        case isJoined = "is_joined"
        case numLearntConcepts = "num_learnt_concepts"
        case numCompletedExercises = "num_completed_exercises"
        case numSolutions = "num_solutions"
        case hasNotifications = "has_notifications"
    }
}
