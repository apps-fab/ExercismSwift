//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct TestSubmission: Codable, Sendable, Hashable {
    public let uuid: String
    public let testsStatus: SubmissionTestsStatus
    public let links: SubmissionLinks

    private enum CodingKeys: String, CodingKey {
        case submission
    }

    private enum SubmissionKeys: String, CodingKey {
        case uuid
        case testsStatus = "tests_status"
        case links
    }

    public init(uuid: String, testsStatus: SubmissionTestsStatus, links: SubmissionLinks) {
        self.uuid = uuid
        self.testsStatus = testsStatus
        self.links = links
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let submissionContainer = try container.nestedContainer(keyedBy: SubmissionKeys.self, forKey: .submission)
        uuid = try submissionContainer.decode(String.self, forKey: .uuid)
        testsStatus = try submissionContainer.decode(SubmissionTestsStatus.self, forKey: .testsStatus)
        links = try submissionContainer.decode(SubmissionLinks.self, forKey: .links)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var submissionContainer = container.nestedContainer(keyedBy: SubmissionKeys.self, forKey: .submission)
        try submissionContainer.encode(uuid, forKey: .uuid)
        try submissionContainer.encode(testsStatus, forKey: .testsStatus)
        try submissionContainer.encode(links, forKey: .links)
    }
}


public enum SubmissionTestsStatus: String, Codable, Sendable, Hashable {
    case notQueued = "not_queued"
    case queued
    case passed
    case failed
    case errored
    case exceptioned
    case cancelled
}
