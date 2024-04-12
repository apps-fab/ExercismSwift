//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct TestRunner: Decodable, Sendable {
    public let averageTestDuration: Int
    public let status: TestRunnerStatus?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        averageTestDuration = try container.decode(Int.self, forKey: .averageTestDuration)
        status = try container.decodeIfPresent(TestRunnerStatus.self, forKey: .status)
    }
}

extension TestRunner {
    enum CodingKeys: String, CodingKey {
        case averageTestDuration = "average_test_duration"
        case status
    }
}

public struct TestRunnerStatus: Decodable, Sendable {
    public let exercise: Bool
    public let track: Bool
}
