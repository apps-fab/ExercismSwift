//
// Created by Kirk Agbenyegah on 26/09/2022.
//

import Foundation

struct ListMeta: Decodable {
    public let currentPage: Int
    public let totalCount: Int
    public let totalPages: Int
}
