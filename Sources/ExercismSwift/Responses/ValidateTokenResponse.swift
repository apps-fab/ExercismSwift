//
// Created by Kirk Agbenyegah on 21/09/2022.
//

import Foundation

public struct ValidateTokenResponse: Decodable {
    public let status: StatusWrapper

    public struct StatusWrapper: Decodable {
        public let token: TokenStatus
    }
}

public enum TokenStatus: String, Decodable {
    case valid
    case invalid
}
