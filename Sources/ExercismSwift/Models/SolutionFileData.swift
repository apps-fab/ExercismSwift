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

    public init(fileName: String,
                content: String,
                type: SolutionFileType = SolutionFileType.exercise,
                digest: String? = nil) {
        self.filename = fileName
        self.content = content
        self.type = type.rawValue
        self.digest = digest
    }
}
