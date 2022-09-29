//
//  Badge.swift
//  
//
//  Created by Angie Mugo on 29/09/2022.
//

import Foundation

public struct Badge {
    public let uuid: String
    public let isRevealed: Bool
    public let unlockedAt: Date
    public let name: String
    public let description: String
    public let rarity: String
    public let iconName: String
    public let numAwardees: Int
    public let percentageAwardees: Int
    public let links: [BadgeLink]


    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String.self, forKey: .uuid)
        isRevealed = try container.decode(Bool.self, forKey: .isRevealed)
        unlockedAt = try container.decode(Date.self, forKey: .unlockedAt)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        rarity = try container.decode(String.self, forKey: .rarity)
        iconName = try container.decode(String.self, forKey: .iconName)
        numAwardees = try container.decode(Int.self, forKey: .numAwardees)
        percentageAwardees = try container.decode(Int.self, forKey: .percentageAwardees)
        links = try container.decode([BadgeLink].self, forKey: .links)
    }
}

extension Badge: Decodable {
    enum CodingKeys: String, CodingKey {
        case uuid
        case isRevealed
        case unlockedAt = "icon_url"
        case name
        case description = "blurb"
        case rarity = "is_external"
        case iconName = "is_unlocked"
        case numAwardees = "is_recommended"
        case percentageAwardees
        case links
    }
}
