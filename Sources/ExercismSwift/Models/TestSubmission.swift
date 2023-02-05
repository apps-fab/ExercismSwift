//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct TestSubmission: Decodable {
    public let uuid: String
    public let testsStatus: SubmissionTestsStatus
    public let links: SubmissionLinks

    enum TestSubmissionKeys: String, CodingKey {
        case uuid
        case testsStatus = "tests_status"
        case links
    }

    private enum CodingKeys: String, CodingKey {
        case submission
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let submissionContainer = try container.nestedContainer(keyedBy: TestSubmissionKeys.self, forKey: .submission)
        uuid = try submissionContainer.decode(String.self, forKey: .uuid)
        testsStatus = try submissionContainer.decode(SubmissionTestsStatus.self, forKey: .testsStatus)
        links = try submissionContainer.decode(SubmissionLinks.self, forKey: .links)
    }
}

public enum SubmissionTestsStatus: String, Decodable {
    case notQueued = "not_queued"
    case queued
    case passed
    case failed
    case errored
    case exceptioned
    case cancelled
}
