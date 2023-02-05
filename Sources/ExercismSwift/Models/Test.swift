//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct Test: Decodable {

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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(TestStatus.self, forKey: .status)
        testCode = try? container.decode(String.self, forKey: .testCode)
        message = try? container.decode(String.self, forKey: .message)
        messageHtml = try? container.decode(String.self, forKey: .messageHtml)
        expected = try? container.decode(String.self, forKey: .expected)
        output = try? container.decode(String.self, forKey: .output)
        outputHtml = try? container.decode(String.self, forKey: .outputHtml)
        taskId = try? container.decodeIfPresent(Int.self, forKey: .taskId)
        index = try? container.decodeIfPresent(Int.self, forKey: .index)
    }
}

extension Test {
    enum CodingKeys: String, CodingKey {
        case name
        case status
        case testCode = "test_code"
        case message
        case messageHtml = "message_html"
        case expected
        case output
        case outputHtml = "output_html"
        case taskId = "task_id"
        case index
    }
}

public enum TestStatus: String, Decodable {
    case error
    case fail
    case pass
}
