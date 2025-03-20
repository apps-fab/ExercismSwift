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

    enum CodingKeys: String, CodingKey {
        case cancel
        case submit
        case testRun = "test_run"
        case initialFiles = "initial_files"
        case lastIterationFiles = "last_iteration_files"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cancel = try container.decode(String.self, forKey: .cancel)
        submit = try container.decode(String.self, forKey: .submit)
        testRun = try container.decode(String.self, forKey: .testRun)
        initialFiles = try container.decode(String.self, forKey: .initialFiles)
        lastIterationFiles = try container.decode(String.self, forKey: .lastIterationFiles)
    }
}
