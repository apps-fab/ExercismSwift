//
// Created by Kirk Agbenyegah on 16/09/2022.
//

import Foundation

public struct BaseInfo {
    public let slug: String
    public let title: String
    public let iconUrl: String


    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        slug = try container.decode(String.self, forKey: .slug)
        title = try container.decode(String.self, forKey: .title)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
    }
}

extension BaseInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case slug
        case title
        case iconUrl = "icon_url"
    }
}