//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct SubmissionLinks: Codable, Sendable, Hashable {
    public let cancel: String
    public let submit: String
    public let testRun: String
    public let initialFiles: String
    public let lastIterationFiles: String
}
