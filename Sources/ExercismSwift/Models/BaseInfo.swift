//
// Created by Kirk Agbenyegah on 16/09/2022.
//

import Foundation

public struct BaseInfo: Sendable, Codable, Hashable {
    public let slug: String
    public let title: String
    public let iconUrl: String
}
