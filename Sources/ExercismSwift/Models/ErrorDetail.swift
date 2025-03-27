//
// Created by Kirk Agbenyegah on 22/09/2022.
//

import Foundation

public struct ErrorDetail: Decodable {
    public let type: String
    public let message: String
}
