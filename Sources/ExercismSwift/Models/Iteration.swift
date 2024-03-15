//
// Created by Kirk Agbenyegah on 08/04/2023.
//

import Foundation

public struct Iteration: Decodable, Sendable {
    public let uuid: String
    public let submissionUUID: String
    public let idx: Int
    public let status: IterationStatus
    public let numEssentialAutomatedComments: Int
    public let numActionableAutomatedComments: Int
    public let numNonActionableAutomatedComments: Int
    public let submissionMethod: String
    public let createdAt: Date
    public let testsStatus: SubmissionTestsStatus
    public let isPublished: Bool
    public let isLatest: Bool
    public let links: IterationLinks

    enum CodingKeys: String, CodingKey {
        case uuid
        case submissionUUID = "submission_uuid"
        case idx
        case status
        case numEssentialAutomatedComments = "num_essential_automated_comments"
        case numActionableAutomatedComments = "num_actionable_automated_comments"
        case numNonActionableAutomatedComments = "num_non_actionable_automated_comments"
        case submissionMethod = "submission_method"
        case createdAt = "created_at"
        case testsStatus = "tests_status"
        case isPublished = "is_published"
        case isLatest = "is_latest"
        case links
    }
}

public struct SubmitSolutionResponse: Decodable, Sendable {
    public let iteration: Iteration

    enum CodingKeys: String, CodingKey {
        case iteration
    }
}
