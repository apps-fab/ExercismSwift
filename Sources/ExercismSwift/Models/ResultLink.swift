//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct ResultLink {
    public let `self`: String
    public let exercises: String?
    public let concepts: String?

    public init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.`self` = try container.decodeIfPresent(String.self, forKey: .`self`) ?? ""
        exercises = try? container.decodeIfPresent(String.self, forKey: .exercises) ?? ""
        concepts = try? container.decodeIfPresent(String.self, forKey: .concepts) ?? ""
    }
}

extension ResultLink: Decodable {
    enum CodingKeys: String, CodingKey {
        case `self`
        case exercises
        case concepts
    }
}