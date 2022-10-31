//
// Created by Kirk Agbenyegah on 29/09/2022.
//

import Foundation

public struct ExerciseConfig: Codable {
    public let authors, contributors: [String]
    public let files: Files
    public let blurb: String

    public struct Files: Codable {
        let solution, test: [String]
    }

    public enum CodingKeys: String, CodingKey {
        case authors, contributors, files
        case blurb
    }
}


