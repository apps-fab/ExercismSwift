//
// Created by Kirk Agbenyegah on 08/04/2023.
//

import Foundation

public struct IterationLinks: Codable, Sendable {
    public let `self`: String
    public let automatedFeedback: String
    public let delete: String
    public let solution: String
    public let testRun: String
    public let files: String
}
