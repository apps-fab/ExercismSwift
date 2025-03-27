//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct Test: Decodable, Sendable {
    public let name: String
    public let status: TestStatus
    public let testCode: String?
    public let message: String?
    public let messageHtml: String?
    public let expected: String?
    public let output: String?
    public let outputHtml: String?
    public let taskId: Int?
    public let index: Int?
}

public enum TestStatus: String, Decodable, Sendable {
    case error
    case fail
    case pass
}
