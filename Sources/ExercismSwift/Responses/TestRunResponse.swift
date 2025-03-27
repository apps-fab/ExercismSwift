//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct TestRunResponse: Decodable, Sendable {
    public let testRun: TestRun?
    public let testRunner: TestRunner
}
