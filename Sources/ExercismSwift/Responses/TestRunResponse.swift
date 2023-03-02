//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct TestRunResponse: Decodable {
    public let testRun: TestRun?
    public let testRunner: TestRunner

    enum CodingKeys: String, CodingKey {
        case testRun = "test_run"
        case testRunner = "test_runner"
    }
}
