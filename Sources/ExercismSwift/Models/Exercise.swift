//
// Created by Kirk Agbenyegah on 16/09/2022.
//

import Foundation

public struct Exercise: Hashable, Sendable {
    public let slug: String
    public let type: String
    public let iconUrl: String
    public let difficulty: String
    public let blurb: String
    public let isExternal: Bool
    public let isUnlocked: Bool
    public let isRecommended: Bool
    public let links: ResultLink

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        slug = try container.decode(String.self, forKey: .slug)
        type = try container.decode(String.self, forKey: .type)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        blurb = try container.decode(String.self, forKey: .blurb)
        isExternal = try container.decode(Bool.self, forKey: .isExternal)
        isUnlocked = try container.decode(Bool.self, forKey: .isUnlocked)
        isRecommended = try container.decode(Bool.self, forKey: .isRecommended)
        links = try container.decode(ResultLink.self, forKey: .links)
    }
}

extension Exercise: Decodable {
    enum CodingKeys: String, CodingKey {
        case slug
        case type
        case iconUrl = "icon_url"
        case difficulty
        case blurb = "blurb"
        case isExternal = "is_external"
        case isUnlocked = "is_unlocked"
        case isRecommended = "is_recommended"
        case links
    }
}
