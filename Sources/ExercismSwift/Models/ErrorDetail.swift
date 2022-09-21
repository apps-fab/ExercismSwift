//
// Created by Kirk Agbenyegah on 22/09/2022.
//

import Foundation

public struct ErrorDetail {
    public let type: String
    public let message: String
}

extension ErrorDetail: Decodable {}


