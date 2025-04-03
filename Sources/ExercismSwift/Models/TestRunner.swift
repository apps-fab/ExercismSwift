//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct TestRunner: Decodable, Sendable {
    public let averageTestDuration: Int
    public let status: TestRunnerStatus?
}

public struct TestRunnerStatus: Decodable, Sendable {
    public let exercise: Bool
    public let track: Bool
}
