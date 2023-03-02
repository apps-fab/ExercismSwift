//
// Created by Kirk Agbenyegah on 05/02/2023.
//

import Foundation

public struct ExerciseMetadata: Codable {
    public let track: String
    public let exercise: String
    public let id: String
    public let url: String
    public let handle: String
    public let isRequester: Bool
    public let autoApprove: Bool

    private enum CodingKeys: String, CodingKey {
        case track, exercise, id, url, handle
        case isRequester = "is_requester"
        case autoApprove = "auto_approve"
    }
}
