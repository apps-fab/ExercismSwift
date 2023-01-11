//
// Created by Kirk Agbenyegah on 29/09/2022.
//

import Foundation

public struct ExerciseConfig: Codable {
    public let authors: [String]
    public let files: Files

    public struct Files: Codable {
        let solution, test: [String]
    }
}


