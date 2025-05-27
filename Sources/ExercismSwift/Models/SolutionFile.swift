//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct SolutionFile: Decodable, Sendable {
    public let id: String
    public let url: String
    public let exercise: SolutionExercise
    public let fileDownloadBaseUrl: String
    public let files: [String]
    public let submittedAt: Date?
}

public struct SolutionResponse: Decodable {
    public let solution: SolutionFile
}
