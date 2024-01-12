//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct TestRun: Decodable {
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

    private enum CodingKeys: String, CodingKey {
        case uuid
        case submissionUuid = "submission_uuid"
        case version
        case status
        case message
        case messageHtml = "message_html"
        case output
        case outputHtml = "output_html"
        case tests
        case tasks
        case highlightjsLanguage = "highlightjs_language"
        case links
    }

}
