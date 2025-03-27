// Content of [SolutionTestFiles]
//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct SolutionFileData: Codable, Sendable {
    public let filename: String
    public let content: String
    public let type: String
    public let digest: String?

    public init(fileName: String, content: String, type: SolutionFileType = SolutionFileType.exercise, digest: String? = nil) {
        filename = fileName
        self.content = content
        self.type = type.rawValue
        self.digest = digest
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filename = try container.decode(String.self, forKey: .filename)
        self.content = try container.decode(String.self, forKey: .content)
        self.type = try container.decode(String.self, forKey: .type)
        self.digest = try container.decodeIfPresent(String.self, forKey: .digest)
    }
}
