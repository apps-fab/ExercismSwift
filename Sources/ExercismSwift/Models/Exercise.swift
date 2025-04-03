//
// Created by Kirk Agbenyegah on 16/09/2022.
//

import Foundation

public struct Exercise: Hashable, Sendable, Decodable {
    public let slug: String
    public let type: String
    public let iconUrl: String
    public let difficulty: String
    public let blurb: String
    public let isExternal: Bool
    public let isUnlocked: Bool
    public let isRecommended: Bool
    public let links: ResultLink
}
