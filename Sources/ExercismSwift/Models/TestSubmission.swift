//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct TestSubmission: Codable, Sendable, Hashable {
    public let submission: SubmissionData

    public var testStatus: SubmissionTestsStatus {
        return submission.testsStatus
    }

    public var links: SubmissionLinks {
        return submission.links
    }
}

public struct SubmissionData: Codable, Sendable, Hashable {
    public let uuid: String
    public let testsStatus: SubmissionTestsStatus
    public let links: SubmissionLinks
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
