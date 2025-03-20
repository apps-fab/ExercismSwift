//
// Created by Kirk Agbenyegah on 26/09/2022.
//

import Foundation

public struct ListMeta {
    public let currentPage: Int
    public let totalCount: Int
    public let totalPages: Int

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentPage = try container.decode(Int.self, forKey: .currentPage)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
    }
}

extension ListMeta: Decodable {
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case totalCount = "total_count"
        case totalPages = "total_pages"
    }
}
