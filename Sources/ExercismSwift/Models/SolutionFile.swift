//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct SolutionFile: Sendable {
    public let id: String
    public let url: String
    public let exercise: SolutionExercise
    public let fileDownloadBaseUrl: String
    public let files: [String]
    public let submittedAt: Date?

    enum SolutionKeys: String, CodingKey {
        case id
        case url
        case exercise
        case fileDownloadBaseUrl = "file_download_base_url"
        case files
        case submission
    }

    enum SubmissionKeys: String, CodingKey {
        case submittedAt = "submitted_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let solutionContainer = try container.nestedContainer(keyedBy: SolutionKeys.self, forKey: .solution)
        id = try solutionContainer.decode(String.self, forKey: .id)
        url = try solutionContainer.decode(String.self, forKey: .url)
        fileDownloadBaseUrl = try solutionContainer.decode(String.self, forKey: .fileDownloadBaseUrl)
        files = try solutionContainer.decode([String].self, forKey: .files)
        exercise = try solutionContainer.decode(SolutionExercise.self, forKey: .exercise)
        let submissionContainer = try? solutionContainer.nestedContainer(keyedBy: SubmissionKeys.self, forKey: .submission)
        submittedAt = try? submissionContainer?.decode(Date.self, forKey: .submittedAt)
    }
}

extension SolutionFile: Decodable {
    enum CodingKeys: String, CodingKey {
        case solution
    }
}

