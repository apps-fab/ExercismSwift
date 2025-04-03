//
//  Badge.swift
//
//
//  Created by Angie Mugo on 29/09/2022.
//

import Foundation

public struct Badge: Decodable {
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
}
