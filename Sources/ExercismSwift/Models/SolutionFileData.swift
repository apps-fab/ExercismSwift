// Content of [SolutionTestFiles]
//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct SolutionFileData: Encodable, Sendable {
    public let filename: String
    public let content: String
    public let type: SolutionFileType
    public let digest: String?

    public init(fileName: String, content: String, type: SolutionFileType = SolutionFileType.exercise, digest: String? = nil) {
        filename = fileName
        self.content = content
        self.type = type
        self.digest = digest
    }
}

