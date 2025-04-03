//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct TestRun: Decodable, Sendable {
    public let uuid: String
    public let submissionUuid: String
    public let version: Int
    public let status: TestRunStatus
    public let message: String?
    public let messageHtml: String?
    public let output: String?
    public let outputHtml: String?
    public let tests: [Test]
    public let tasks: [ExercismTask]
    public let highlightjsLanguage: String
    public let links: ResultLink
}
