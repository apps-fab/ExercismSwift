//
// Created by Kirk Agbenyegah on 21/09/2022.
//

import Foundation

public struct ValidateTokenResponse {
    public let status: TokenStatus

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawStatus = try container.decode([String: String].self, forKey: .status)
        let token = rawStatus.first(where: { $0.key == "token" })
        if token?.value == "valid" {
            status = .valid
        } else {
            status = .invalid
        }
    }

}

public enum TokenStatus {
    case valid
    case invalid
}

extension ValidateTokenResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case status
    }
}