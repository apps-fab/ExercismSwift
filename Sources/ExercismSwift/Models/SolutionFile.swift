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

    private enum CodingKeys: String, CodingKey {
        case id, url, exercise, files, submission
        case fileDownloadBaseUrl = "file_download_base_url"
    }

    private enum SubmissionKeys: String, CodingKey {
        case submittedAt = "submitted_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        fileDownloadBaseUrl = try container.decode(String.self, forKey: .fileDownloadBaseUrl)
        files = try container.decode([String].self, forKey: .files)
        exercise = try container.decode(SolutionExercise.self, forKey: .exercise)

        // Handle nested submission key
        let submissionContainer = try? container.nestedContainer(keyedBy: SubmissionKeys.self, forKey: .submission)
        submittedAt = try? submissionContainer?.decode(Date.self, forKey: .submittedAt)
    }
}


