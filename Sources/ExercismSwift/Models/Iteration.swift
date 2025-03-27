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
}

public struct SubmitSolutionResponse: Decodable, Sendable {
    public let iteration: Iteration
}
