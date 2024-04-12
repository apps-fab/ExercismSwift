//
// Created by Kirk Agbenyegah on 08/04/2023.
//

import Foundation

public struct IterationLinks: Codable, Sendable {
    public let selfLink: String
    public let automatedFeedback: String
    public let delete: String
    public let solution: String
    public let testRun: String
    public let files: String

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case automatedFeedback = "automated_feedback"
        case delete
        case solution
        case testRun = "test_run"
        case files
    }
}
