//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct SolutionExercise: Sendable, Decodable {
    public let id: String
    public let instructionsUrl: String
    public let trackId: String
    public let trackLanguage: String
}

enum SolutionExerciseTrackKeys: String, CodingKey {
    case id
    case language
}
