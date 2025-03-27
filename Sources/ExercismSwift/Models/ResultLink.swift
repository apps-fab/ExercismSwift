//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct ResultLink: Sendable, Codable, Hashable {
    public let `self`: String?
    public let exercises: String?
    public let concepts: String?
}
